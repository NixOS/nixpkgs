{ lib
, buildPythonApplication
, mkYarnModules
, fetchFromGitHub
, gdb
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, python-socketio
, eventlet
, python
, nodejs
}:

buildPythonApplication rec {
  pname = "gdbgui";

  baseVersion = "0.15.0.1";
  version = "${baseVersion}-unstable-2022-06-22";

  buildInputs = [ gdb ];

  nativeBuildInputs = [ nodejs ];

  propagatedBuildInputs = [
    flask-socketio
    flask-compress
    pygdbmi
    pygments
    python-socketio
    eventlet
  ];

  # fix: KeyError: WERKZEUG_SERVER_FD
  # https://github.com/cs01/gdbgui/pull/430
  # cannot apply patch to binary release
  src = fetchFromGitHub {
    owner = "cs01";
    repo = "gdbgui";
    rev = "9138473156116340c2b1c0b72d35dba32b4a3bd6";
    sha256 = "sha256-d8DDfASKIqLGngpsofdi2fskafOX4YbsfQGVt9bj9L4=";
  };

  gdbgui-node-modules = mkYarnModules {
    pname = "gdbgui-node-modules";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };

  preBuild = ''
    mkdir node_modules
    shopt -s dotglob # node_modules/.bin
    ln -s ${gdbgui-node-modules}/node_modules/* node_modules
    shopt -u dotglob

    # fix: sh: line 1: cross-env: command not found
    export PATH=$PWD/node_modules/.bin:$PATH

    # fix: Error: No PostCSS Config found in node_modules/xterm/css
    rm node_modules/xterm
    cp -r --no-preserve=mode ${gdbgui-node-modules}/node_modules/xterm node_modules/xterm
    echo 'module.exports = {};' >node_modules/xterm/css/postcss.config.js

    # fix: ERR_OSSL_EVP_UNSUPPORTED
    export NODE_OPTIONS=--openssl-legacy-provider

    npm run build
  '';

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # relax dependencies
    sed -i 's/==.*$//' requirements.txt
  '';

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ gdb ]}" ];

  # tests do not work without stdout/stdin
  doCheck = false;

  meta = with lib; {
    description = "A browser-based frontend for GDB";
    homepage = "https://www.gdbgui.com/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk dump_stack ];
  };
}
