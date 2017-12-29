{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-${shortVersion}";

  shortVersion = "20170613";
  longVersion = "2017-06-13T19-01-01Z";

  src = fetchurl {
    url = "https://github.com/minio/minio/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "1rrlgn0nsvfn0lr9ffihjdb96n4znsvjlz1h7bwvz8nwhbn0lfsf";
  };

  buildInputs = [ go ];

  unpackPhase = ''
    d=$TMPDIR/src/github.com/minio/minio
    mkdir -p $d
    tar xf $src -C $d --strip-component 1
    export GOPATH=$TMPDIR
    cd $d
  '';

  buildPhase = ''
    mkdir -p $out/bin
    go build -o $out/bin/minio \
      --ldflags "-X github.com/minio/minio/cmd.Version=${longVersion}"
  '';

  installPhase = "true";

  meta = {
    homepage = https://www.minio.io/;
    description = "An S3-compatible object storage server";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.x86_64;
    license = lib.licenses.asl20;
  };
}
