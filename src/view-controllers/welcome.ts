import fs from 'fs/promises';
import path from 'path';
import ejs from 'ejs';

import getAppInfo from '../data/getAppInfo';
import globalStyles from './globalStyles';
import getUserFromToken from '../data/getUserFromToken';

const welcome = async (req, res) => {
  const { app, token } = req.query;

  if (!token) {
    res.statusCode = 307;
    res.setHeader('Location', '/login');
    return res.end();
  }

  const file = await fs.readFile(path.join(__dirname, '../templates', `welcome.html`));

  const appInfo = await getAppInfo(app);

  const user = await getUserFromToken('pre-verify', token);

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
