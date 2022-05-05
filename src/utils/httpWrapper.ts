const httpWrapper = (cb) => async (req, res) => {
  const output = await Promise.resolve(cb(req));

  if (output.headers && Array.isArray(output.headers)) {
    output.headers.forEach(([name, value]) => {
      res.setHeader(name, value);
    });
  }

  if (output.statusCode) {
    res.statusCode = output.statusCode;
  }

  if (output.body) {
    return res.end(output.format === 'json' ? JSON.stringify(output.body) : output.body);
  }

  return res.end();
};

export default httpWrapper;
