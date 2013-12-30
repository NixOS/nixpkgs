{ stdenv, fetchurl, openssl, perl }:

stdenv.mkDerivation rec {
  version = "0.3";
  name = "chunksync-${version}";

  src = fetchurl {
    url = "http://chunksync.florz.de/chunksync_${version}.tar.gz";
    sha256 = "e0c27f925c5cf811798466312a56772864b633728c433fb2fcce23c8712b52fc";
  };

  buildInputs = [openssl perl];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Space-efficient incremental backups of large files or block devices";
    homepage = "http://chunksync.florz.de/";
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
  };
}
