var express = require('express'),
    bodyParser = require('body-parser'),
    props = require('./common/props'),
    logger = require('./common/logger');

var app = express();

app.use(bodyParser.urlencoded({
  extended: false
}));
app.use(bodyParser.json());

// TODO health check
// app.get('/_healthz', health);
app.get('/', (req, res) => {
  console.log('console: broker is running...');
  logger.info('logger: broker is running...');
  res.send('res: broker is running...');
});

app.get('/debug', (req, res) => {
  console.log('console: debugging...');
  logger.debug('logger: debugging...');
  res.send('res: debugging...');
});

app.get('/error', (req, res) => {
  console.log('console: erroring...');
  logger.error('logger: erroring...');
  res.send('res: erroring...');
});

// start broker
var port = props.NODE_PORT;
app.listen(port);
logger.info('broker listening on port ' + port);
