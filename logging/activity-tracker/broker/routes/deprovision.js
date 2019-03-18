var express = require('express'),
    props = require('../common/props'),
    logger = require('../common/logger');

var router = express.Router();

router.delete('/v2/service_instances/:instance_id', (req, res) => {
  logger.info('processing deprovision request...');

  const broker_api_version_header = props.BR_API_VER_HEADER;
  const broker_api_version = props.BR_API_VER;
  logger.debug('broker api version header: ' + broker_api_version_header);
  logger.debug('broker api version: ' + broker_api_version);

  var api_version = req.get(broker_api_version_header);

  if (!api_version || broker_api_version > parseFloat(api_version)) {
    res.writeHead(412, [{
      'Content-Type': 'text/plain'
    }]);
    res.write('Precondition failed. Missing or incompatible ' + broker_api_version_header + '. Expecting version ' + broker_api_version + ' or later.');
    res.end();
  } else {
    var catalogJSON = JSON.parse(require('fs').readFileSync('config/catalog.json', 'utf8'));


    const provider_ep = props.PR_ENDPOINT;
    const provider_apikey = props.PR_APIKEY;
    logger.debug('provider_ep: ' + provider_ep);
    logger.debug('provider_apikey: ' + provider_apikey);

    // construct request payload
    // TODO

    // send request
    // TODO

    // check response
    // TODO

    // construct rc-response payload
    // TODO

    // send rc_response
    res.writeHead(200, [{
      'Content-Type': 'application/json'
    }]);
    res.send('returning deprovision route...'); //TODO tmp response - placeholder - replace
    res.end();
  }
})

module.exports = router
