const props = require('./props');

const { createLogger, format, transports } = require('winston');
const { colorize, combine, timestamp, printf } = format;

let logger;

const formatLog = printf(info => {
   return `{"message":"${info.message}"}`;
});

if (props.NODE_ENV === 'production') {
  logger = createLogger({
    transports: [
      new(transports.Console)({
        level: 'info'
      })
    ]
  });
} else { // dev
  logger = createLogger({
    format: combine(
      timestamp(),
      formatLog
    ),
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
        filename: '/var/log/debug.log',
        level: 'debug',
      }),
      // new winston.transports.File({
      //   filename: 'silly.log',
      //   level: 'silly'
      // })
    ]
  });
}

logger.verbose('logger instantiated');

module.exports = logger;
