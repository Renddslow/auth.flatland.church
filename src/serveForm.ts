import { ServerResponse } from 'http';
import fs from 'fs/promises';
import ejs from 'ejs';
import * as path from 'path';
import { URL } from 'url';

import apps from './apps';
import globalStyles from './globalStyles';
import logo from './logo';

const atLeastMatchesHost = (target: string, canonical: string): boolean => {
  if (target === canonical) return true;

  return safelyMakeURL(target).host === safelyMakeURL(canonical).host;
};

const safelyMakeURL = (url: string): URL | Record<string, any> => {
  try {
    return new URL(url);
  } catch (e) {
    return {};
  }
};

const serveForm = (form) => async (req, res: ServerResponse) => {
  const { callbackURL, app } = req.query;
  const file = await fs.readFile(path.join(__dirname, '../templates', `${form}.html`));

  const appInfo = apps[app];

  if (callbackURL && !app) {
    const url = new URL(callbackURL);
    url.searchParams.set('error', 'NoAppError');
    res.setHeader('Location', url.toString());
    res.statusCode = 307;
    return res.end();
  }

  if (callbackURL && !atLeastMatchesHost(callbackURL, appInfo[app]?.callbackURL)) {
    const url = new URL(callbackURL);
    url.searchParams.set('error', 'InvalidCallbackError');
    res.setHeader('Location', url.toString());
    res.statusCode = 307;
    return res.end();
  }

  const html = ejs.render(file.toString(), {
    // @ts-ignore
    csrf: req.csrfToken(),
    appName: appInfo?.appName || 'Flatland Church',
    app,
    callbackURL: callbackURL || appInfo[app]?.callbackURL,
    globalStyles,
    searchParams: req.search || '',
    logo,
  });
  res.setHeader('Content-Type', 'text/html');
  res.end(html);
};

export default serveForm;
