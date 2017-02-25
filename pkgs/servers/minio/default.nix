{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-${shortVersion}";

  shortVersion = "20170125";
  longVersion = "2017-01-25T03-14-52Z";

  src = fetchurl {
    url = "https://github.com/minio/minio/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "0yh8fdgl50sza182kl4jly0apf0dw0ya954ky6j8a8hmdcmk6wzk";
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
