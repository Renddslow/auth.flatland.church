import fs from 'fs/promises';
import path from 'path';
import ejs from 'ejs';

import getAppInfo from '../data/getAppInfo';
import globalStyles from './globalStyles';
import getUserFromToken from '../data/getUserFromToken';
import verifyToken from '../data/verifyToken';
import { JwtPayload } from 'jsonwebtoken';

const welcome = async (req, res) => {
  const { token } = req.query;

  if (!token) {
    res.statusCode = 307;
    res.setHeader('Location', '/login');
    return res.end();
  }

  const file = await fs.readFile(path.join(__dirname, '../templates', `welcome.html`));

  const verifiedToken = verifyToken('pre-verify', token);

  const appInfo = await getAppInfo((verifiedToken as JwtPayload)?.app);

  const user = await getUserFromToken(verifiedToken);

  const html = ejs.render(file.toString(), {
    globalStyles,
    status: user?.email_is_verified ? null : 'verify',
    firstName: user?.first_name,
    email: user?.email,
    appName: appInfo?.name || 'Flatland Church',
    apps: [],
  });

  res.setHeader('Content-Type', 'text/html');
  res.end(html);
};

export default welcome;
