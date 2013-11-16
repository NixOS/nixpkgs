{ stdenv, fetchurl, go, fetchgit, fetchbzr, fetchhg }:

let
  go-websocket = fetchgit {
    url = "git://github.com/garyburd/go-websocket";
    rev = "4bad98c955";
    sha256 = "1zh1r1xqar47awgv8a883zmxyvj65m0mbdm17d1xf74nkkrcykqy";
  };
  go-metrics = fetchgit {
    url = "https://github.com/inconshreveable/go-metrics";
    rev = "60ba4ca70c";
    sha256 = "3dc8c229ce5123d86269c0c48401a9cdd2cde7558d85374c9dbc4bbd531e86d5";
  };
  termbox-go = fetchgit {
    url = "https://github.com/nsf/termbox-go";
    rev = "cea198fce7";
    sha256 = "bde4190ae83d5c5870b8e11e16387cf03f2d44a8369f94674d4b9d0960c40693";
  };
  go-bindata = fetchgit {
    url = "https://github.com/inconshreveable/go-bindata";
    rev = "99016b3cc0";
    sha256 = "518a5b61cfbe58f8bc55bd6139adcd69997b6ba474536a70b538879aaf118578";
  };
  go-update = fetchgit {
    url = "https://github.com/inconshreveable/go-update";
    rev = "3f04666667";
    sha256 = "34647689a50b9d12e85a280d9034cc1772079163481c4778ee4b3e6c4b41e2f4";
  };
  goyaml = fetchbzr {
    url = "https://launchpad.net/goyaml";
    sha256 = "03is37cgw62cha316xrs5h7q97im46ry5qldkfvbhimjq3ww0swj";
    # Branch: "branch:lp:goyaml"
    revision = 47;
  };
  log4go = fetchhg {
    url = "https://code.google.com/p/log4go/";
    tag = "c3294304d93f";
    sha256 = "0q906sxrmwir295virfibqvdzlaj340qh2r4ysx1ccjrjazc0q5p";
  };
  osext = fetchhg {
    url = "https://bitbucket.org/kardianos/osext";
    tag = "364fb57";
    sha256 = "1w9x2zj716agfd5x5497ajb9nz3ljar74768vjidsyly143vzjws";
  };
in stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/inconshreveable/ngrok/archive/${version}.tar.gz";
    sha256 = "0w54ck00ma8wd87gc3dligypdjs7vrzbi9py46sqphsid3rihkjr";
  };

  buildInputs = [ go ];

  preBuild = ''
    export HOME="$PWD"

    mkdir -p src/github.com/garyburd/go-websocket/
    ln -s ${go-websocket}/* src/github.com/garyburd/go-websocket

    mkdir -p src/github.com/inconshreveable/go-metrics/
    ln -s ${go-metrics}/* src/github.com/inconshreveable/go-metrics

    mkdir -p src/github.com/inconshreveable/go-bindata
    ln -s ${go-bindata}/* src/github.com/inconshreveable/go-bindata

    mkdir -p src/github.com/inconshreveable/go-update
    ln -s ${go-update}/* src/github.com/inconshreveable/go-update

    mkdir -p src/github.com/nsf/termbox-go/
    ln -s ${termbox-go}/* src/github.com/nsf/termbox-go

    mkdir -p src/launchpad.net/goyaml
    ln -s ${goyaml}/* src/launchpad.net/goyaml

    mkdir -p src/code.google.com/p/log4go
    ln -s ${log4go}/* src/code.google.com/p/log4go

    mkdir -p src/bitbucket.org/kardianos/osext
    ln -s ${osext}/* src/bitbucket.org/kardianos/osext

    # don't download dependencies as we already have them
    sed -i '/go get/d' Makefile
  '';

  installPhase = ''
    make release-client
    mkdir -p $out/bin
    cp bin/ngrok $out/bin
    cp -R assets $out
  '';

  meta = with stdenv.lib; {
    description = "Reverse proxy that creates a secure tunnel between from a public endpoint to a locally running web service";
    homepage = https://ngrok.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
