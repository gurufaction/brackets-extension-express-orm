/*jslint vars: true, plusplus: true, devel: true, nomen: true, regexp: true, indent: 4, maxerr: 50 */
/*global define, $, brackets, window, Mustache */

/** Sencha Extension */
define(function (require, exports, module) {
    "use strict";

    var CommandManager  = brackets.getModule("command/CommandManager"),
        Menus           = brackets.getModule("command/Menus"),
        Dialogs         = brackets.getModule("widgets/Dialogs"),
        ExtensionUtils  = brackets.getModule("utils/ExtensionUtils"),
        Strings         = brackets.getModule("strings"),
        ProjectManager  = brackets.getModule("project/ProjectManager"),
        //ProjectDialogTemplate  = require('text!htmlContent/wizard-dialog.html'),
        //ModelDialogTemplate     = require('text!htmlContent/model-dialog.html'),
        //FieldDialogTemplate     = require('text!htmlContent/field-dialog.html'),
        OrmModelTemplate        = require('text!templates/orm/model.tpl'),
        RouteModelTemplate      = require('text!templates/express/route.tpl'),
        ConfigTemplate      = require('text!templates/express/config.tpl'),
        AppTemplate      = require('text!templates/express/app.tpl'),
        FileUtils               = brackets.getModule("file/FileUtils"),
        NativeFileSystem        = brackets.getModule("file/NativeFileSystem").NativeFileSystem;
    
    var projectVars;
    
    function _getFilename(path) {
        return path.substr(path.lastIndexOf("/") + 1);
    }
    
    function _getRootDir(path) {
        return path.substring(0, path.lastIndexOf("/"));
    }
    
    function _convertToPath(name) {
        var path = name.replace(/\./g, "/");
        return {
            "filename"      : _getFilename(path),
            "fullPath"      : path,
            "rootDir"       : _getRootDir(path)
        };
    }
        
    function _createFile(filePath, template, entityVars, options) {
        if (options === undefined) {
            options = {create : true, exclusive: false};
        }
        var rootDir = _getRootDir(filePath);
        var filename = _getFilename(filePath);
        // Get Project Root Directory
        var projectDir = ProjectManager.getProjectRoot();
        console.log(rootDir + ":" + filename + ":" + filePath + ":" + options);
        projectDir.getDirectory(rootDir, options,
            function (dir) {
                console.log(dir);
                var file = new NativeFileSystem.FileEntry(dir.fullPath + filename, true, NativeFileSystem.FileSystem);
                console.log(file);
                FileUtils.writeText(file, Mustache.render(template, entityVars)).done(function () {
                    console.log("File created: " + file.fullPath);
                }).fail(function (err) {
                    console.log("Error writing text: " + file.fullPath);
                });
            }, function (err) {
                console.log(err.name + ":" + rootDir);
            });
    }
    
    function getOrmType(type) {
        var ormType;
        switch (type) {
        case "int":
        case "integer":
            ormType = "Number";
            break;
        case "date":
        case "datetime":
            ormType = "Date";
            break;
        case "bool":
        case "boolean":
            ormType = "Boolean";
            break;
        default:
            ormType = "String";
            break;
        }
        return ormType;
    }
    
    function _readProjectFile() {
        var projectDir = ProjectManager.getProjectRoot();
        
        projectDir.getFile("project.json", {create: false}, function (fileEntry) {
            FileUtils.readAsText(fileEntry).done(function (rawText, readTimestamp) {
                projectVars = JSON.parse(rawText);
                var models = [], model, x, f, fields = [], field;
                
                for (x = 0; x < projectVars.MODELS.length; x++) {
                    fields = [];
                    for (f = 0; f < projectVars.MODELS[x].FIELDS.length; f++) {
                        if (projectVars.MODELS[x].FIELDS[f].NAME !== "id") {
                            field = {
                                "NAME" : projectVars.MODELS[x].FIELDS[f].NAME,
                                "TYPE" : getOrmType(projectVars.MODELS[x].FIELDS[f].TYPE),
                                "LAST" : false
                            };
                            fields.push(field);
                        }
                    }
                    fields[fields.length - 1].LAST = true;
                    model = {
                        "ROUTE"     : projectVars.MODELS[x].NAME.toLowerCase(),
                        "NAME"      : projectVars.MODELS[x].NAME,
                        "FIELDS"    : fields,
                        "LAST"      : false
                    };
                    console.log(model);
                    models.push(model);
                    var ormFile = projectVars.SRC_DIR + "/" + projectVars.SERVER_DIR + "/orm/model/" + model.NAME + ".js";
                    var routeFile = projectVars.SRC_DIR + "/" + projectVars.SERVER_DIR + "/express/route/" + model.NAME + ".js";
                    _createFile(ormFile, OrmModelTemplate, model);
                    _createFile(routeFile, RouteModelTemplate, model);
                }
                models[models.length - 1].LAST = true;
                projectVars.MODELS = models;
                projectVars.PORT = "8080";
                var configFile = projectVars.SRC_DIR + "/" + projectVars.SERVER_DIR + "/express/config.js";
                _createFile(configFile, ConfigTemplate, projectVars);
                var appFile = projectVars.SRC_DIR + "/" + projectVars.SERVER_DIR + "/app.js";
                _createFile(appFile, AppTemplate, projectVars);
                
            }).fail(function (err) {
                console.log("Error reading text: " + err.name);
            });
        }, function (err) {
            console.log("Project File Not Found!");
            return err;
        });
    }
    
    function openExpressConfigDialog() {
    }
    
    function generateAll() {
        console.log(projectVars);
        console.log("Load Project File.");
        _readProjectFile();
        console.log(projectVars);
    }
    
    function generateRoute() {
    }
    
    // First, register a command - a UI-less object associating an id to a handler
    //var EXPRESS_CONFIG_COMMAND_ID       = "com.gurufaction.express.configure";   // package-style naming to avoid collisions
    //var EXPRESS_ROUTE_COMMAND_ID        = "com.gurufaction.express.route";
    var EXPRESS_ALL_COMMAND_ID    = "com.gurufaction.express.all";
    
    //CommandManager.register("Express Configuration", EXPRESS_CONFIG_COMMAND_ID, openExpressConfigDialog);
    CommandManager.register("Generate All", EXPRESS_ALL_COMMAND_ID, generateAll);
    //CommandManager.register("Generate Routes", EXPRESS_ROUTE_COMMAND_ID, generateRoute);

    // Then create a menu item bound to the command
    // The label of the menu item is the name we gave the command (see above)
    var menu = Menus.getMenu(Menus.AppMenuBar.FILE_MENU);
    //menu.addMenuItem(EXPRESS_CONFIG_COMMAND_ID, "Ctrl-P", Menus.First);
    //menu.addMenuItem(EXPRESS_ROUTE_COMMAND_ID);
    menu.addMenuItem(EXPRESS_ALL_COMMAND_ID);
});