import { ServerResponse } from 'http';
import fs from 'fs/promises';
import ejs from 'ejs';
import * as path from 'path';

import apps from './apps';
import globalStyles from './globalStyles';
import logo from './logo';

const serveForm = (form) => async (req, res: ServerResponse) => {
  const file = await fs.readFile(path.join(__dirname, '../templates', `${form}.html`));
  const html = ejs.render(file.toString(), {
    // @ts-ignore
    csrf: req.csrfToken(),
    appName: apps[req.query.app]?.appName || 'Flatland Church',
    app: req.query.app,
    callbackURL: req.query.callbackURL,
    globalStyles,
    searchParams: req.search || '',
    logo,
  });
  res.setHeader('Content-Type', 'text/html');
  res.end(html);
};

export default serveForm;
