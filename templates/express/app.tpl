var express = require('express');
var orm = require('orm');
var app = express();

require('./express/config')(app, orm);
{{#ROUTES}}
require('./express/routes/{{NAME}}')(app, orm);
{{/ROUTES}}

app.listen({{PORT}});
console.log("Server Started on port: {{PORT}} ...");