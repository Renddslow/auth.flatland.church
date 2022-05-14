import { User, PrismaClient } from '@prisma/client';
import to from 'await-to-js';
import verifyToken from './verifyToken';
import { JwtPayload } from 'jsonwebtoken';

const prisma = new PrismaClient();

const getUserFromToken = async (
  type: 'pre-verify' | 'server' = 'server',
  token: string,
): Promise<User | null> => {
  const payload = verifyToken(type, token);

  if (!payload) return null;

  const [err, user] = await to(
    prisma.user.findUnique({
      where: {
        id: (payload as JwtPayload)?.id as number,
      },
    }),
  );

  if (err) return null;

  return user;
};

export default getUserFromToken;
