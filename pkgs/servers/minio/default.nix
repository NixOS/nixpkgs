{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-${version}";

  version = "2017-09-29T19-16-56Z";

  src = fetchurl {
    url = "https://github.com/minio/minio/archive/RELEASE.${version}.tar.gz";
    sha256 = "1h028gyfvyh5x6k4fsj4s64sgzqy7jgln6kvs27bnxzigj6dp2wx";
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
      --ldflags "-X github.com/minio/minio/cmd.Version=${version}"
  '';

  installPhase = "true";

  meta = {
    homepage = https://www.minio.io/;
    description = "An S3-compatible object storage server";
    maintainers = with lib.maintainers; [ eelco bachp ];
    platforms = lib.platforms.x86_64;
    license = lib.licenses.asl20;
  };
}
