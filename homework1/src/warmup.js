const crypto = require('crypto'); // eslint-disable-line import/no-extraneous-dependencies
const rp = require('request-promise');

const change = (cents) => {
  const numberOfCoins = [];
  let centsRemaining = cents;
  if (centsRemaining < 0) { throw new RangeError('amount cannot be negative'); }
  [25, 10, 5, 1].forEach((element) => {
    numberOfCoins.push(Math.floor(centsRemaining / element));
    centsRemaining %= element;
  });
  return numberOfCoins;
};

const stripQuotes = (string) => {
  const stringToStrip = string;
  return stringToStrip.split('').filter(char => char !== '"' && char !== '\'').join('');
};

const scramble = (string) => {
  const stringArray = string.split('');
  let finalString = [];
  // iterates over copy of stringArray, safe from mutation
  stringArray.slice().forEach((val, index) => {
    const randomNumber = Math.floor(Math.random() * (string.length - index));
    const randomChar = stringArray.splice(randomNumber, 1);
    finalString = finalString.concat(randomChar);
  });
  return finalString.join('');
};

const powers = (base, limit, callback) => {
  let currentValue = 1;
  if (currentValue < 1) { return; }
  while (currentValue <= limit) {
    callback(currentValue);
    currentValue *= base;
  }
};

// Arrow functions cannot be used as generator functions
function* powersGenerator(base, limit) {
  let currentValue = 0;
  while (base ** currentValue <= limit) {
    yield base ** currentValue;
    currentValue += 1;
  }
}

const say = (msg) => {
  const out = [];
  function sayCurrier(nextMsg) {
    if (!nextMsg) {
      return out.join(' ');
    }
    out.push(nextMsg);
    return sayCurrier;
  }
  return sayCurrier(msg);
};

const interleave = (arrayA, ...arrayB) => {
  const arrA = arrayA;
  const arrB = arrayB;
  const interleavedArr = [];

  while (arrA.length > 0 || arrB.length > 0) {
    if (arrA.length > 0) { interleavedArr.push(arrA.shift()); }
    if (arrB.length > 0) { interleavedArr.push(arrB.shift()); }
  }
  return interleavedArr;
};

const cylinder = (spec) => {
  let { radius = 1, height = 1 } = spec;
  const volume = () => Math.PI * (radius ** 2) * height;
  const surfaceArea = () => (2 * Math.PI * (radius * height)) + (2 * Math.PI * (radius ** 2));
  const widen = (factor) => { radius *= factor; };
  const stretch = (factor) => { height *= factor; };
  const toString = () => `Cylinder with radius ${radius} and height ${height}`;
  return Object.freeze({
    volume,
    surfaceArea,
    widen,
    stretch,
    toString,
    get radius() { return radius; },
    get height() { return height; },
  });
};

const makeCryptoFunctions = (cryptoKey, cryptoAlg) => {
  // Adapted from: http://lollyrock.com/articles/nodejs-encryption/
  const encrypt = (text) => {
    const cipher = crypto.createCipher(cryptoAlg, cryptoKey);
    let crypted = cipher.update(text, 'utf8', 'hex');
    crypted += cipher.final('hex');
    return crypted;
  };

  const decrypt = (text) => {
    const decipher = crypto.createDecipher(cryptoAlg, cryptoKey);
    let dec = decipher.update(text, 'hex', 'utf8');
    dec += decipher.final('utf8');
    return dec;
  };
  return [encrypt, decrypt];
};

const randomName = (params) => {
  const { gender, region } = params;
  return rp({
    method: 'GET',
    uri: 'https://uinames.com/api/',
    qs: {
      gender,
      region,
      amount: 1,
    },
    headers: {
      'User-Agent': 'LMU Programming Languages HW',
    },
    json: true, // Automatically parses the JSON string in the response
  }).then(data => `${data.surname}, ${data.name}`);
};

module.exports = {
  change,
  stripQuotes,
  scramble,
  powers,
  powersGenerator,
  say,
  interleave,
  cylinder,
  makeCryptoFunctions,
  randomName,
};
