import { App, PrismaClient } from '@prisma/client';
import to from 'await-to-js';

const prisma = new PrismaClient();

const getAppInfo = async (shortcode?: string): Promise<App | null> => {
  if (!shortcode) return null;

  const [err, app] = await to(
    prisma.app.findUnique({
      where: {
        shortcode,
      },
    }),
  );

  if (err) return null;
  return app;
};

export default getAppInfo;
