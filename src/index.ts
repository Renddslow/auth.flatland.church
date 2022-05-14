import polka from 'polka';
import cors from 'cors';
import { json, urlencoded } from 'body-parser';
import csurf from 'csurf';
import cookieParser from 'cookie-parser';
import sirv from 'sirv';

import serveForm from './view-controllers/serveForm';
import createAccountFromFrontend from './controllers/createAccountFromFrontend';
import welcome from './view-controllers/welcome';

const PORT = process.env.PORT || 8080;

const xsrf = csurf({ cookie: true });

const noRobots = () => (req, res, next) => {
  res.setHeader('X-Robots-Tag', 'noindex');
  next();
};

const assets = sirv('public', {
  maxAge: 31536000, // 1Y
  immutable: true,
});

polka()
  .use(cors(), json(), urlencoded({ extended: true }), cookieParser(), noRobots(), assets)
  // Static
  .get('/', (_, res) => {
    res.setHeader('Location', '/login');
    res.statusCode = 307;
    res.end('');
  })
  .get('/login', xsrf, serveForm('login'))
  .get('/create-account', xsrf, serveForm('create-account'))
  .get('/welcome', welcome)
  .get('/verify', () => {})
  .post('/login', xsrf, () => {})
  .post('/create-account', xsrf, createAccountFromFrontend)
  // Only API method open to other services
  .get('/api/permissions')
  /** Admin portal */
  .get('/admin')
  .get('/admin/login')
  .get('/admin/users')
  .get('/admin/users/:userId')
  .listen(PORT, () => console.log(`🔐 Running Flatland Auth on port ${PORT}`));
