import fs from 'fs/promises';
import path from 'path';
import { render } from 'ejs';
import globalStyles from '../view-controllers/globalStyles';

const handleIntent = async (req, res) => {
  const intent = req.query.next;

  const file = await fs.readFile(path.join(__dirname, '../templates', 'intent.html'));

  res.statusCode = 307;
  res.setHeader('Content-Type', 'text/html');
  res.end(render(file.toString(), { intent, globalStyles }));
};

export default handleIntent;
