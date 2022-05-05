export const requestWrapper = (req, res) => {};

export const customRequestWrapper = (transformer, cb) => (req) => {
  return cb(transformer(req));
};

export const responseWrapper = () => {};
