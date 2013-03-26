module.exports = function (app, mysql, options) {
    function getConnection() {
        return mysql.createConnection(options);
    }
    
    app.get("/{{ROUTE}}", function (req, res) {
        var connection = getConnection();
        connection.query('SELECT * FROM {{NAME}}', function(err, rows, fields) {
            if (err) res.send(500,err);
            var response = new Object();
            response.results = new Array();
            console.log(rows);
            if( rows != undefined ) {
                response.total = rows.length;
                for(var x in rows)
                {
                    var customer = new Object();
                    customer.id = rows[x].id;
                    customer.name = rows[x].name;
                    customer.status = new Object();
                    customer.status.id = rows[x].status_id;
                    customer.status.name = rows[x].status_name;
                    response.results[x] = customer;
                    console.log(customer);
                }
            }
            res.send(response);
        });
        connection.end();
    });
    
    app.get("/{{ROUTE}}/:id", function (req, res) {
        req.db.models.{{NAME}}.get(req.params.id, function (err, entity) {
            res.send(entity);
        });
    });
    
    app.post("/{{ROUTE}}/", function (req, res) {
        {{NAME}}.create([
            {
                {{#FIELDS}}
                {{NAME}}: req.body.{{NAME}}{{^LAST}},{{/LAST}}
                {{/FIELDS}}
            }
        ], function (err, items) {
            // err - description of the error or null
            // items - array of inserted items
        });
    });
    
    app.put("/{{ROUTE}}/:id", function (req, res) {
        req.db.models.{{NAME}}.get(req.params.id, function (err, entity) {
            
            {{#FIELDS}}
            entity.{{NAME}} = req.body.{{NAME}};
            {{/FIELDS}}
            entity.save(function (err) {
                
            });
            res.send(entity);
        });
    });
    
    app.delete("/{{ROUTE}}/:id", function (req, res) {
        req.db.models.{{NAME}}.get(req.params.id, function (err, entity) {
            entity.delete_time = new Date();
            entity.save(function (err) {
                
            });
            res.send(entity);
        });
    });
};