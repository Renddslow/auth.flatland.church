import fs from 'fs/promises';
import path from 'path';
import { render } from 'ejs';

import globalStyles from './globalStyles';

export type RequiredPayload = {
  firstName: string;
  lastName: string;
  email: string;
};

const createEmailBody = async (
  template: string,
  payload: RequiredPayload & Record<string, any>,
) => {
  const file = await fs.readFile(
    path.join(__dirname, '../templates', 'emails', `${template}.html`),
  );
  return render(file.toString(), {
    ...payload,
    footer: await getEmailFooter(payload),
    globalStyles,
  });
};

const getEmailFooter = async (payload: RequiredPayload): Promise<string> => {
  const file = await fs.readFile(path.join(__dirname, '../templates', 'emails', `_footer.html`));
  return render(file.toString(), payload);
};

export default createEmailBody;
