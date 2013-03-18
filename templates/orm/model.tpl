module.exports = function (db, cb) {
    db.define('{{NAME}}', {
        {{#FIELDS}}
        {{NAME}} : {{TYPE}}{{^LAST}},{{/LAST}}
        {{/FIELDS}}
    });

    return cb();
};