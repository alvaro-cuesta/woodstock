// LESS 'CSS' wrapper for SocketStream 0.3

var fs = require('fs'),
    less = require('less');

exports.init = function(root, config) {
  return {
    name: 'LESS',
    extensions: ['less'],
    assetType: 'css',
    contentType: 'text/css',
    compile: function(path, options, cb) {

      // Get dir from path to enable @include commmand
      var dir = path.split('/'); dir.pop();
      var input = fs.readFileSync(path, 'utf8');
      var compress = options && options.compress;

      var parser = new(less.Parser)({
          paths: [dir.join('/')],
          filename: path
      });

      parser.parse(input, function (e, tree) {
          if (e) {
              var message = '! - Unable to compile LESS file %s into CSS';
              console.log(String.prototype.hasOwnProperty('red') && message.red || message, path);
              console.log(e.type + ' error: [' + e.index + '] ' + e.message + '\n' +
                          e.filename + ':' + e.line + ':' + e.column + '\n' +
                          e.extract.join('\n'));
          }
          cb(tree.toCSS({ compress: compress }));
      });
    }
  };
};
