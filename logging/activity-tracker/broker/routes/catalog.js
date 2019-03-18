var express = require('express'),
    props = require('../common/props'),
    logger = require('../common/logger');

var router = express.Router();

router.get('/v2/catalog', (req, res) => {
  logger.info('processing catalog request...');

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

    // override service definition values
    catalogJSON.services.id = props.SVC_ID;
    catalogJSON.services.plans.id = props.PLAN_ID;

    // send service definition
    res.writeHead(200, [{
      'Content-Type': 'application/json'
    }]);
    res.write(JSON.stringify(catalogJSON));
    res.end();
  }
})

module.exports = router
