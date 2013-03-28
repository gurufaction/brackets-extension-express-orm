module.exports = function (app) {
    app.get("/{{ROUTE}}", function (req, res) {
        req.db.models.{{NAME}}.find().limit(parseInt(req.query.limit)).offset(parseInt(req.query.start)).run(function (err, results) {
            var response = {
                results : [],
                success : false
            };
            
            if (err){
                response.error = err;
            } else{
                response.total = results.length;
                response.results = results;
            }
            res.send(response);
        });
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