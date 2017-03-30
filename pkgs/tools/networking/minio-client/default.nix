{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-client-${shortVersion}";

  shortVersion = "20170206";
  longVersion = "2017-02-06T20-16-19Z";

  src = fetchurl {
    url = "https://github.com/minio/mc/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "0k66kr7x669jvydcxp3rpvg8p9knhmcihpnjiqynhqgrdy16mr1f";
  };

  buildInputs = [ go ];

  unpackPhase = ''
    d=$TMPDIR/src/github.com/minio/mc
    mkdir -p $d
    tar xf $src -C $d --strip-component 1
    export GOPATH=$TMPDIR
    cd $d
  '';

  buildPhase = ''
    mkdir -p $out/bin
    go build -o $out/bin/minio-client \
      --ldflags "-X github.com/minio/mc/cmd.Version=${longVersion}"
  '';

  installPhase = "ln -s minio-client $out/bin/mc";

  meta = {
    homepage = https://github.com/minio/mc;
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
}
