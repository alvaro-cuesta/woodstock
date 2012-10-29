var http = require('http'),
    ss = require('socketstream');

// MAIN PAGE
ss.client.define('main', {
    view: 'app.jade',
    css:  ['libs/foundation.css', 'app.less'],
    code: ['libs/jquery.min.js',
           'libs/jquery.foundation.mediaQueryToggle.js',
           'libs/jquery.foundation.forms.js',
           'libs/jquery.foundation.reveal.js',
           'libs/jquery.foundation.orbit.js',
           'libs/jquery.foundation.navigation.js',
           'libs/jquery.foundation.buttons.js',
           'libs/jquery.foundation.tabs.js',
           'libs/jquery.foundation.tooltips.js',
           'libs/jquery.foundation.accordion.js',
           'libs/jquery.placeholder.js',
           'libs/jquery.foundation.alerts.js',
           'libs/jquery.foundation.topbar.js',
           'libs/modernizr.foundation.js',
           'libs/app.js',
           'app',
           'views',
           'piv'],
    tmpl: '*'
});

ss.http.route('/').serveClient('main');

// PLUGINS
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('./ss-less'));
ss.client.templateEngine.use(require('ss-hogan'));

// MINIFY IN PRODUCTION
if (ss.env === 'production') ss.client.packAssets();

// START SERVERS
var server = http.Server(ss.http.middleware);
server.listen(3000);
var consoleServer = require('ss-console')(ss);
consoleServer.listen(5000);

ss.start(server);