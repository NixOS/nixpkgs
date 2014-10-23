{ stdenv, fetchFromGitHub, lessc, closurecompiler }:

stdenv.mkDerivation rec {
  name = "twitter-bootstrap-${version}";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "twitter";
    repo = "bootstrap";
    rev =  "v${version}";
    sha256 = "0b4dsk9sqlkwwfgqqjlgi6p05qz2jssmmz4adm83f31sx70lgh4g";
  };  

  buildInputs = [ lessc closurecompiler ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/css $out/js $out/img
    cp $src/img/* $out/img/
    closure-compiler --js $src/js/*.js > $out/js/bootstrap.js
    lessc $src/less/bootstrap.less -O2 -x > $out/css/bootstrap.css
  ''; 

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = http://getbootstrap.com/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
