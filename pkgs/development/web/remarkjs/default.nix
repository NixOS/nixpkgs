{ stdenv, lib, fetchgit, fetchurl, nodejs, nodePackages }:

with lib;

let

  # highlight.js is a git submodule of remark
  highlightjs = fetchgit {
    url = https://github.com/isagalaev/highlight.js;
    rev = "10b9500b67983f0a9c42d8ce8bf8e8c469f7078c";
    sha256 = "1yy8by15kfklw8lwh17z1swpj067q0skjjih12yawbryraig41m0";
  };

in stdenv.mkDerivation rec {
  name = "remarkjs-${version}";

  version = "0.6.5";

  src = fetchurl {
    url = "https://github.com/gnab/remark/archive/v${version}.tar.gz";
    sha256 = "1bh3hmhq99qqd3qg747xwjqkyppc9vf3b5nhi56556rwc02cn17p";
  };

  buildInputs = with nodePackages; [
    nodejs
    marked
    browserify
    uglify-js
    less
    mocha
    mocha-phantomjs
    phantomjs
    should
    sinon
    jshint
    shelljs
  ];

  configurePhase = ''
    mkdir -p node_modules/.bin
    ${concatStrings (map (dep: ''
      test -d ${dep}/bin && (for b in $(ls ${dep}/bin); do
        ln -sv -t node_modules/.bin ${dep}/bin/$b
      done)
    '') buildInputs)}
  '';

  buildPhase = ''
    substituteInPlace make.js --replace "target.test();" ""
    substituteInPlace make.js --replace vendor/highlight.js ${highlightjs}
    node make all
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v out/* $out/lib/
  '';

  meta = {
    homepage = http://remarkjs.com;
    description = "A simple, in-browser, markdown-driven slideshow tool.";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
