var http = require('http'),
    ss = require('socketstream'),
    mongo = require('mongodb'),
    Server = mongo.Server,
    Db = mongo.Db;

var server = new Server('localhost', 27017, {auto_reconnect: true, safe: true});
var db = new Db('woodstock', server);

db.open(function(err, db) {
    if (!err) {
        // MAIN PAGE
        ss.client.define('main', {
            view: 'app.jade',
            css:  ['libs/reset.css',
                   'libs/bootstrap.css',
                   'app.styl'],
            code: ['libs/jquery.min.js',
                   'app'],
            tmpl: '*'
        });

        ss.http.route('/').serveClient('main');

        // RESPONSIVE PAGE
        ss.client.define('responsive', {
            view: 'app.jade',
            css:  ['libs/reset.css',
                   'libs/bootstrap-responsive.css',
                   'app.styl'],
            code: ['libs/jquery.min.js',
                   'app'],
            tmpl: '*'
        });

        ss.http.route('/responsive', function(req, res){
            if (req.headers['user-agent'].match(/iPhone/))
                res.serveClient('responsive');
            else
                res.serveClient('main');
        });

        // PLUGINS
        ss.client.formatters.add(require('ss-coffee'));
        ss.client.formatters.add(require('ss-jade'));
        ss.client.formatters.add(require('ss-stylus'));
        ss.client.formatters.add(require('./ss-less'));
        ss.client.templateEngine.use(require('ss-hogan'));

        // ENABLE DB API
        ss.api.add('db', db);

        // MINIFY IN PRODUCTION
        if (ss.env === 'production') ss.client.packAssets();

        // START SERVERS
        var server = http.Server(ss.http.middleware);
        server.listen(3000);
        var consoleServer = require('ss-console')(ss);
        consoleServer.listen(5000);

        ss.start(server);

    } else {
        console.log("Unable to connect to MongoDB");
    }
});
