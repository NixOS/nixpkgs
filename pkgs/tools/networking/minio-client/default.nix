{ lib, stdenv, fetchurl, go }:

stdenv.mkDerivation rec {
  name = "minio-client-${shortVersion}";

  shortVersion = "20160821";
  longVersion = "2016-08-21T03:02:49Z";

  src = fetchurl {
    url = "https://github.com/minio/mc/archive/RELEASE.${lib.replaceStrings [":"] ["-"] longVersion}.tar.gz";
    sha256 = "1qnslwfspbvzawxrrym27agw79x8sgcafk7d0yakncjyg6vmdkka";
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
