import { PrismaClient } from '@prisma/client';
import argon2 from 'argon2';
import cookie from 'cookie';

import verifyToken from '../data/verifyToken';
import jwt, { JwtPayload } from 'jsonwebtoken';

const prisma = new PrismaClient();

const verifyEmail = async (req, res) => {
  const payload = verifyToken('server', req.query.token);

  if (!payload) {
    res.statusCode = 302;
    res.setHeader('Location', '/error?code=InvalidPayloadError');
    return res.end();
  }

  const user = await prisma.user.findUnique({
    where: {
      id: (payload as JwtPayload)?.id,
    },
  });

  if (!user.email_verification_code) {
    res.statusCode = 302;
    res.setHeader('Location', '/error?code=OldCodeError');
    return res.end();
  }

  const codesMatch = await argon2.verify(user.email_verification_code, req.query.code);

  if (!codesMatch) {
    res.statusCode = 302;
    res.setHeader('Location', '/error?code=InvalidCodeError');
    return res.end();
  }

  await prisma.user.update({
    where: {
      id: (payload as JwtPayload)?.id,
    },
    data: {
      email_is_verified: true,
      email_verification_code: null,
      email_verified_at: new Date(),
    },
  });

  const cookieToken = jwt.sign(
    {
      id: (payload as JwtPayload)?.id,
    },
    process.env.SERVER_SECRET,
    {
      expiresIn: '18 Weeks',
    },
  );

  const cookieOpts = {
    httpOnly: true,
    maxAge: 60 * 60 * 24 * 7 * 18, // 18 weeks
    // secure
  };

  const cookies = [
    cookie.serialize('_fc_account', cookieToken, { ...cookieOpts, domain: 'flatland.church' }),
    cookie.serialize('_fc_account', cookieToken, { ...cookieOpts, domain: 'flatlandchurch.com' }),
  ].join(',');

  res.statusCode = 302;
  res.setHeader('Set-Cookie', cookies);
  res.setHeader('access-control-expose-headers', 'Set-Cookie');
  res.setHeader('Location', `/intent?next=${(payload as JwtPayload)?.callbackURL}`);
  return res.end();
};

export default verifyEmail;
