{ stdenv, fetchurl, fetchhg, go, sqlite}:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64);

stdenv.mkDerivation rec {
  name = "storebrowse-20130316140138";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/storebrowse/tarball/storebrowse-881990147c.tar.gz?uuid=881990147c";
    name = "${name}.tar.gz";
    sha256 = "183b6gz7xv88c94i9mgmjslsdn75v5vsbchl19kjv7mbrxfx5mvl";
  };

  srcGoSqlite = fetchhg {
    url = "https://code.google.com/p/gosqlite/";
    tag = "5baefb109e18";
    sha256 = "0mqfnx06jj15cs8pq9msny2z18x99hgk6mchnaxpg343nzdiz4zk";
  };

  buildPhase = ''
    PATH=${go}/bin:$PATH
    mkdir $TMPDIR/go
    export GOPATH=$TMPDIR/go

    GOSQLITE=$GOPATH/src/code.google.com/p/gosqlite
    mkdir -p $GOSQLITE
    cp -R $srcGoSqlite/* $GOSQLITE/
    export CGO_CFLAGS=-I${sqlite}/include
    export CGO_LDFLAGS=-L${sqlite}/lib
    go build -ldflags "-r ${sqlite}/lib" -o storebrowse
  '';

  installPhase = ''
    ensureDir $out/bin
    cp storebrowse $out/bin
  '';

  meta = {
    homepage = http://viric.name/cgi-bin/storebrowse;
    license = "AGPLv3+";
  };
}
