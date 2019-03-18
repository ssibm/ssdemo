const props = require('./props');
const auth = require('../config/auth');
// const cadf = require('./CadfTemplate').makeCADF();

const { createLogger, format, transports } = require('winston');
const { colorize, combine, timestamp, printf } = format;

let at;

const formatCADF = printf(info => {

  let cadf = {
    "action": "swarmAT.event.create",
    "eventTime": (new Date()).toISOString(),
    "initiator": {
      "id": "hdngo@us.ibm.com",
      "name": "hdngo@us.ibm.com",
      "typeURI": "swarmAT/event/create",
      "credential": {
        "type": "user"
      },
      "host": {
        // "agent": "",
        // "address": ""
      }
    },
    "target": {
      "id": `crn:v1:bluemix:public:hello-at:${auth.service_provider_region}:s/${auth.service_provider_project_id}:1234-5678-9012-3456:greeting:1`,
      "name": "Swarm AT",
      "typeURI": "swarmAT/event/create",
      "host": {
        // "address": ""
      }
    },
    "reason": {
      "reasonCode": 200,
      // "reasonType": ""
    },
    "outcome": "success",
    "requestData": JSON.stringify({
      "name": "Huy Ngo",
    }),
    "responseData": JSON.stringify({
      "greeting": `Hello!`
    })
  };

  // The meta fields tell how to deliver the event to the service and to the user
  let meta = {
    // These three fields are the info you registered to AT.
    // They tell AT how to deliver a copy of the event to your service
    "serviceProviderName": auth.serviceProviderName,
    "serviceProviderRegion": auth.serviceProviderRegion,
    "serviceProviderProjectId": auth.serviceProviderProjectId,

    // These fields tell how to deliver a copy of the event to the user.
    // Either provide account or space, not both, and comment out the one you don't use.
    "userAccountIds": [auth.userAccountId], // must be array of 1
    // "userSpaceId": auth.userSpaceId,
    "userSpaceRegion": auth.userSpaceRegion
  };

  let message = {
    "payload": cadf,
    "meta": meta
  };

  return JSON.stringify(message);
});

if (props.NODE_ENV === 'production') {
  at = createLogger({
    transports: [
      new(transports.Console)({
        level: 'info'
      })
    ]
  });
} else { // dev
  at = createLogger({
    format: formatCADF,
    transports: [
      new(transports.Console)({
        level: 'debug',
      }),
      // Ascending log levels
      // Each log level will log itself and all logs above it
      // new winston.transports.File({
      //   filename: 'error.log',
      //   level: 'error'
      // }),
      // new winston.transports.File({
      //   filename: 'warn.log',
      //   level: 'warn'
      // }),
      // new winston.transports.File({
      //   filename: 'info.log',
      //   level: 'info'
      // }),
      // new winston.transports.File({
      //   filename: 'verbose.log',
      //   level: 'verbose'
      // }),
      new transports.File({
        filename: '/var/log/at/debugAT.log',
        level: 'debug',
      }),
      // new winston.transports.File({
      //   filename: 'silly.log',
      //   level: 'silly'
      // })
    ]
  });
}

at.verbose('at instantiated');

module.exports = at;
