module.exports = function (app, orm) {
    app.use(orm.express("{{PROVIDER}}://{{USERNAME}}:{{PASSWORD}}@{{HOST}}/{{DATABASE}}", {
        define: function (db) {
            {{#MODELS}}
            db.load("./orm/model/{{NAME}}", function (err) {
                console.log("{{NAME}} Model Loaded.");
            });
            {{/MODELS}}
        },
        error: function (err) {
            console.log(err);
        }
    }));
};