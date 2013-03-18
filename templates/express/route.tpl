module.exports = function (app) {
    app.get("/{{ROUTE}}", function (req, res) {
        req.db.models.{{NAME}}.find({ }, function (err, results) {
            var response = {
                results : [],
                success : false
            };
            response.total = results.length;
            response.results = results;
            res.send(response);
        });
    });
    
    app.get("/{{ROUTE}}/:id", function (req, res) {
        req.db.models.{{NAME}}.get(req.param.id, function (err, result) {
            res.send(result);
        });
    });
    
    app.delete("/{{ROUTE}}/:id", function (req, res) {
        req.db.models.{{NAME}}.get(req.param.id, function (err, result) {
            result.delete_time = new Date();
            result.save(function (err) {
                // err.msg = "under-age";
            });
            res.send(result);
        });
    });
};