var fprops = JSON.parse(require('fs').readFileSync('config/broker.json', 'utf8'));

function getEVStr(name) {
  if (process.env[name]) {
    module.exports[name] = process.env[name];
  } else if (fprops[name]) {
      module.exports[name] = fprops[name];
  } else {
    throw Error(name + ' not set in environment variables');
  }
}

function getEVInt(name) {
  if (process.env[name]) {
    const temp = Number.parseInt(process.env[name]);
    if (Number.isNaN(temp)) {
      throw Error('environment variable ' + name + ' is not an integer');
    } else {
      module.exports[name] = temp;
    }
  } else if (fprops[name]) {
      const temp = Number.parseInt(fprops[name]);
      if (Number.isNaN(temp)) {
        throw Error('environment variable ' + name + ' is not an integer');
      } else {
        module.exports[name] = temp;
      }
  } else {
      throw Error(name + ' not set in environment variables');
  }
}

function getEVFloat(name) {
  if (process.env[name]) {
    const temp = Number.parseFloat(process.env[name]);
    if (Number.isNaN(temp)) {
      throw Error('environment variable ' + name + ' is not a float');
    } else {
      module.exports[name] = temp;
    }
  } else if (fprops[name]) {
      const temp = Number.parseFloat(fprops[name]);
      if (Number.isNaN(temp)) {
        throw Error('environment variable ' + name + ' is not a float');
      } else {
        module.exports[name] = temp;
      }
  } else {
      throw Error(name + ' not set in environment variables');
  }
}

getEVStr('SVC_ID');
getEVStr('PLAN_ID');
getEVStr('PR_APIKEY');
getEVStr('PR_ENDPOINT');
getEVStr('BR_API_VER_HEADER');
getEVFloat('BR_API_VER');
getEVStr('BR_USER');
getEVStr('BR_PASS');
getEVStr('NODE_ENV');
getEVStr('NODE_PORT');
