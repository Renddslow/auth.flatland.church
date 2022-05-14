import sgMail from '@sendgrid/mail';

sgMail.setApiKey(process.env.SENDGRID_KEY);

const sendEmail = (email: string, subject: string, body: string) => {
  return sgMail
    .send({
      to: email,
      content: [
        {
          type: 'text/html',
          value: body,
        },
      ],
      from: {
        email: 'no-reply@flatland.church',
        name: 'Flatland Church Account',
      },
      replyTo: {
        email: 'mubatt@wyopub.com',
        name: 'Matt McElwee',
      },
      subject,
    })
    .catch((e) => console.error(e));
};

export default sendEmail;
