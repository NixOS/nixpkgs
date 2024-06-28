{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ethercalc";
  version = "0.20201228.1";

  src = fetchFromGitHub {
    owner = "audreyt";
    repo = "ethercalc";
    rev = "b196277081d677be991d104e454a52d242ef0189";
    hash = "sha256-RJS62lcQV9hgCfJ0cMw08eijssA7OVzbpjnAjVAqm/4=";
  };

  npmDepsHash = "sha256-ks84Hdqz7hxLrHg76mZVykudzthYZEp9qRTcETFBL18=";

  dontNpmBuild = true;

  preBuild = ''
    substituteInPlace node_modules/uglify-js/tools/node.js \
      --replace 'sys = require("util");' 'sys = require("console");'
    substituteInPlace node_modules/uglify-js/bin/uglifyjs \
      --replace 'sys = require("util");' 'sys = require("console");' \
      --replace 'sys.print' 'sys.log'
  '';

  buildFlags = [ "all" ];

  meta = with lib; {
    description = "Online collaborative spreadsheet";
    license = with licenses; [ cpal10 artistic2 mit asl20 cc0 mpl20 ];
    homepage = "https://github.com/audreyt/ethercalc";
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
  };
}
