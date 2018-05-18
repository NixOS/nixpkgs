{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium
, keyutils, liburcu, zlib, libaio, zstd }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-04-10";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "c598d91dcb0c7e95abdacb2711898ae14ab52ca1";
    sha256 = "1mglw6p1145nryn8babkg2hj778kqa0vrzjbdp9kxjlyb3fksmff";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ attr libuuid libscrypt libsodium keyutils liburcu zlib libaio zstd ];
  patches = [ ./Makefile.patch ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = https://bcachefs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno];
    platforms = platforms.linux;
  };
}
