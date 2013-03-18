module.exports = function (app, orm) {
    app.use(orm.express("{{DATABASE_TYPE}}://{{USERNAME}}:{{PASSWORD}}@{{HOST}}/{{DATABASE}}", {
        define: function (db) {
            {{#MODELS}}
            db.load("./orm/models/{{NAME}}", function (err) {
                console.log("{{NAME}} Model Loaded.");
            });
            {{/MODELS}}
        },
        error: function (err) {
            console.log(err);
        }
    }));
};