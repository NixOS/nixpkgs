{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-${shortVersion}";

  shortVersion = "20160821";
  longVersion = "2016-08-21T02:44:47Z";

  src = fetchurl {
    url = "https://github.com/minio/minio/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "159196bnb4b7f00jh9gll9kqqxq1ifxv1kg5bd6yjpqf5qca4pkn";
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
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
}
