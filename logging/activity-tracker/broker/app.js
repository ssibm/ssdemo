var express = require('express'),
    bodyParser = require('body-parser');
    basicAuth = require('basic-auth');

var props = require('./common/props'),
    // logger = require('./common/logger'),
    at = require('./common/at'),
    catalog = require('./routes/catalog');
    provision = require('./routes/provision');
    deprovision = require('./routes/deprovision')

var app = express();

app.use(bodyParser.urlencoded({
  extended: false
}));
app.use(bodyParser.json());

// TODO health check
// app.get('/_healthz', health);
app.get('/', (req, res) => {
  console.log('console: broker is running...');
  // logger.info('logger: broker is running...');
  at.info('at: broker is running...');
  res.send('res: broker is running...');
});

app.get('/debug', (req, res) => {
  console.log('console: debugging...');
  // logger.debug('logger: debugging...');
  at.debug('at: debugging...');
  res.send('res: debugging...');
});

app.get('/error', (req, res) => {
  console.log('console: erroring...');
  // logger.error('logger: erroring...');
  at.error('at: erroring...');
  res.send('res: erroring...');
});

app.get('/activity-tracker', (req, res) => {
  console.log('console: activity tracker...');
  // logger.info('logger: activity tracker...');
  at.info('at: activity tracker...');
  res.send('res: activity tracker...');
});

// Auth for broker
const auth_user = props.BR_USER;
const auth_pass = props.BR_PASS;
app.all('/v2/*', (req, res, next) => {
  function unauthorized(res) {
    res.set('WWW-Authenticate', 'Basic realm=Authorization Required');
    return res.send(401);
  };

  var user = basicAuth(req);

  if (!user || !user.name || !user.pass) {
    return unauthorized(res);
  }

  if (user.name === auth_user && user.pass === auth_pass) {
    return next();
  } else {
    return unauthorized(res);
  }
});

// GET catalog
app.get('/v2/catalog', catalog);

// PUT service instance
app.put('/v2/service_instances/:instance_id', provision);

// DELETE service instance
app.delete('/v2/service_instances/:instance_id', deprovision);

// start broker
var port = props.NODE_PORT;
app.listen(port);
at.info('broker listening on port ' + port);
