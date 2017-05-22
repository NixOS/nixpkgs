{ stdenv, lib, fetchzip, makeWrapper, git, nodejs-7_x, yarn, postgresql, redis }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "heroku-${version}";
  version = "6.6.14";

  src = fetchzip {
    url = "https://github.com/heroku/cli/archive/v6.6.14.tar.gz";
    sha256 = "0z81swpszy0zlg7y4v0yw9kwhfj3m75cc4s9qqp71vaj4c5gnn80";
  };

  meta = {
    homepage = "https://devcenter.heroku.com/articles/heroku-cli";
    description = "A tool for creating and managing Heroku apps from the command line";
    maintainers = with maintainers; [ aflatter mirdhyn peterhoeg ];
    license = licenses.isc;
    platforms = with platforms; unix;
  };

  buildInputs = [ git makeWrapper (yarn.override { nodejs = nodejs-7_x; }) ];

  binPath = lib.makeBinPath [ nodejs-7_x postgresql redis ];

  buildPhase = ''
    export HOME=$TMPDIR
    yarn install
  '';

  installPhase = ''
    mkdir -p $out/{bin,libexec/heroku}
    cp -R . $out/libexec/heroku
    makeWrapper $out/libexec/heroku/bin/run $out/bin/heroku \
      --prefix PATH : ${binPath}
  '';
}
