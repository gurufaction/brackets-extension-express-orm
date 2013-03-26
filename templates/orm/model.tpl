module.exports = function (db, cb) {
    var {{NAME}} = db.define('{{NAME}}', {
        {{#FIELDS}}
        {{NAME}} : {{TYPE}}{{^LAST}},{{/LAST}}
        {{/FIELDS}}
    });

    {{#HASONE}}
    {{NAME}}.hasOne("{{NAME}}", {{NAME}});
    {{/HASONE}}
    {{#HASMANY}}
    {{NAME}}.hasMany("{{NAME}}", {{NAME}});
    {{/HASMANY}}
    return cb();
};