{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-${shortVersion}";

  shortVersion = "20161213";
  longVersion = "2016-12-13T17:19:42Z";

  src = fetchurl {
    url = "https://github.com/minio/minio/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "1x23arrah54q2zqhgpyag531mimvs0wx6ap0hdrn4mygy5dahrqs";
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
