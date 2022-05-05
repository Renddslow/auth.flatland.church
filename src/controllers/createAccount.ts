import { PrismaClient } from '@prisma/client';
import argon2 from 'argon2';
const prisma = new PrismaClient();

export const createAccountFromFrontend = async ({ firstName, lastName, email, password }) => {
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
