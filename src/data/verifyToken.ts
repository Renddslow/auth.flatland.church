import jwt from 'jsonwebtoken';

const verifyToken = (type: 'pre-verify' | 'server' = 'server', token: string) => {
  const secret = type === 'pre-verify' ? process.env.PRE_VERIFY_SECRET : process.env.SERVER_SECRET;

  try {
    return jwt.verify(token, secret);
  } catch (e) {
    return null;
  }
};

export default verifyToken;
