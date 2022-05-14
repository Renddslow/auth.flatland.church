import { PrismaClient } from '@prisma/client';
import argon2 from 'argon2';
import jwt from 'jsonwebtoken';
import to from 'await-to-js';

import httpWrapper from '../utils/httpWrapper';
import { customRequestWrapper } from '../utils/jsonAPIWrapper';
import createVerificationCode from './createVerificationCode';
import createEmailBody from '../view-controllers/createEmailBody';
import getAppInfo from '../data/getAppInfo';
import sendEmail from '../utils/sendEmail';

const prisma = new PrismaClient();

const createAccountFromFrontend = async ({
  firstName,
  lastName,
  email,
  password,
  app,
  inviteCode,
  callbackURL,
}) => {
  const emailVerificationCode = createVerificationCode();

  const [err, user] = await to(
    prisma.user.create({
      data: {
        first_name: firstName,
        last_name: lastName,
        email,
        password: await argon2.hash(password),
        email_verification_code: await argon2.hash(emailVerificationCode),
      },
    }),
  );

  if (err) {
    return {
      body: {
        errors: [
          {
            status: 400,
            title: 'Email already exists',
            detail: `The provided email "${email}" already exists in our system.`,
            code: 'EmailExistsError',
          },
        ],
      },
      format: 'json',
      statusCode: 400,
    };
  }

  if (inviteCode) {
    const [, invite] = await to(
      prisma.appInvite.findFirst({
        where: {
          invite_code: inviteCode,
        },
      }),
    );

    if (invite) {
      await to(
        prisma.appInvite.update({
          where: { id: invite.id },
          data: {
            accepted_at: new Date(),
            email: null,
            user: {
              connect: {
                id: user.id,
              },
            },
          },
        }),
      );
    }
  }

  const frontendToken = jwt.sign(
    {
      id: user.id,
      firstName,
      lastName,
      email,
      app,
      callbackURL,
    },
    process.env.PRE_VERIFY_SECRET,
  );

  const emailToken = jwt.sign(
    {
      id: user.id,
      firstName,
      lastName,
      email,
      app,
      callbackURL,
      emailVerificationCode,
    },
    process.env.SERVER_SECRET,
  );

  const appInfo = await getAppInfo(app);

  const body = await createEmailBody('verification', {
    token: emailToken,
    emailVerificationCode,
    firstName,
    lastName,
    email,
    app: appInfo?.name || '',
  });

  await sendEmail(email, `${firstName}, please verify your email address`, body);

  return {
    headers: [['Location', `/welcome?token=${frontendToken}`]],
    statusCode: 302,
  };
};

export default httpWrapper(
  customRequestWrapper(
    (req) => ({
      firstName: req.body['first-name'],
      lastName: req.body['last-name'],
      email: req.body.email,
      password: req.body['new-password'],
      app: req.body.app,
      inviteCode: req.body.inviteCode,
      callbackURL: req.body.callbackURL,
    }),
    createAccountFromFrontend,
  ),
);
