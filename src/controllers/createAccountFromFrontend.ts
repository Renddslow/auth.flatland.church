import { PrismaClient } from '@prisma/client';
import argon2 from 'argon2';
import httpWrapper from '../utils/httpWrapper';
import { customRequestWrapper } from '../utils/jsonAPIWrapper';
const prisma = new PrismaClient();

const createAccountFromFrontend = async ({ firstName, lastName, email, password }) => {
  await prisma.user.create({
    data: {
      first_name: firstName,
      last_name: lastName,
      email,
      password: await argon2.hash(password),
    },
  });

  // TODO: send email verification

  return {
    headers: [['Location', '/welcome']],
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
    }),
    createAccountFromFrontend,
  ),
);
