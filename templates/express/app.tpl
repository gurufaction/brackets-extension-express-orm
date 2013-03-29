var express = require('express');
var expressWinston = require('express-winston');
var winston = require('winston');
var orm = require('orm');
var app = express();

require('./express/config')(app, orm);
app.use(express.bodyParser());

// Request Logging
app.use(expressWinston.logger({
  transports: [
    new winston.transports.File({
      json: true,
      colorize: true,
      filename: '../../logs/request.log'
    })
  ]
}));

app.use("/ext", express.static("{{PROJECT_DIR}}/lib/ext"));
app.use(express.static("{{PROJECT_DIR}}/src/client"));

app.get('/', function(req, res) {
	res.sendfile('/index.html');
});

{{#MODELS}}
require('./express/route/{{NAME}}')(app, orm);
{{/MODELS}}

// Error Logging
app.use(expressWinston.errorLogger({
  transports: [
    new winston.transports.File({
      json: true,
      colorize: true,
      filename: '../../logs/error.log'
    })
  ]
}));

app.listen({{PORT}});
console.log("Server Started on port: {{PORT}} ...");