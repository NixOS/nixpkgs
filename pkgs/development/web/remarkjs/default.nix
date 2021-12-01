{ stdenv, lib, fetchFromGitHub, nodejs, phantomjs2, pkgs }:

with lib;

let

  # highlight.js is a git submodule of remark
  highlightjs = fetchFromGitHub {
    owner = "isagalaev";
    repo = "highlight.js";
    rev = "10b9500b67983f0a9c42d8ce8bf8e8c469f7078c";
    sha256 = "1yy8by15kfklw8lwh17z1swpj067q0skjjih12yawbryraig41m0";
  };

  nodePackages = import ./nodepkgs.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };

in
stdenv.mkDerivation rec {
  pname = "remarkjs";

  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gnab";
    repo = "remark";
    rev = "v${version}";
    sha256 = "sha256-zhHuW4pBqXQEBlSxuyvHKh+ftyIdcqpYgIZZHArUtns=";
  };

  buildInputs = [ nodejs phantomjs2 ] ++ (with nodePackages; [
    marked
    browserify
    uglify-js
    less
    mocha
    #mocha-phantomjs
    should
    sinon
    jshint
    shelljs
  ]);

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
    homepage = "https://remarkjs.com";
    description = "A simple, in-browser, markdown-driven slideshow tool";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    broken = true;
  };
}
