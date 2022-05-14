import fs from 'fs/promises';
import path from 'path';
import ejs from 'ejs';

import getAppInfo from '../data/getAppInfo';
import globalStyles from './globalStyles';

const welcome = async (req, res) => {
  const { app } = req.query;

  const file = await fs.readFile(path.join(__dirname, '../templates', `welcome.html`));

  const appInfo = await getAppInfo(app);

  // getUser

  const html = ejs.render(file.toString(), {
    globalStyles,
    status: '',
    firstName: '',
    appName: appInfo?.name || 'Flatland Church',
    apps: [],
  });

  res.setHeader('Content-Type', 'text/html');
  res.end(html);
};

export default welcome;
