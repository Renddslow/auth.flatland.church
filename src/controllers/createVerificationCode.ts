const createVerificationCode = (): string => {
  return Array(6)
    .fill(null)
    .map(() => Math.floor(Math.random() * 10))
    .map((num) => num.toString(10))
    .join('');
};

export default createVerificationCode;
