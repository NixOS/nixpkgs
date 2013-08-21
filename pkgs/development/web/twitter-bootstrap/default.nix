{ stdenv, fetchgit, lessc, closurecompiler }:

stdenv.mkDerivation rec {
  name = "twitter-bootstrap-${version}";
  version = "2.3.2";

  src = fetchgit {
    url = https://github.com/twitter/bootstrap.git;
    rev = "refs/tags/v${version}";
    sha256 = "093z4yxqhrr30vna67ksxz3bq146q2xr05hinh78pg2ls88k77la";
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
