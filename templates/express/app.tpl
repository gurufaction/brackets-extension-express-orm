var express = require('express');
var orm = require('orm');
var app = express();

require('./express/config')(app, orm);
app.use(express.bodyParser());
app.use("/ext", express.static("{{PROJECT_DIR}}/lib/ext"));
app.use(express.static("{{PROJECT_DIR}}/src/client"));

app.get('/', function(req, res) {
	res.sendfile('/index.html');
});

{{#MODELS}}
require('./express/route/{{NAME}}')(app, orm);
{{/MODELS}}

app.listen({{PORT}});
console.log("Server Started on port: {{PORT}} ...");