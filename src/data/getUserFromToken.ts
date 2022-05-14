import { User, PrismaClient } from '@prisma/client';
import to from 'await-to-js';
import { JwtPayload } from 'jsonwebtoken';

const prisma = new PrismaClient();

const getUserFromToken = async (token: JwtPayload | string | null): Promise<User | null> => {
  if (!token) return null;

  const [err, user] = await to(
    prisma.user.findUnique({
      where: {
        id: (token as JwtPayload)?.id as number,
      },
    }),
  );

  if (err) return null;

  return user;
};

export default getUserFromToken;
