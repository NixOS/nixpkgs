{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium
, keyutils, liburcu, zlib, libaio, zstd }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-03-20";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "ff5e165532a2eed87700649d03f91a612a58e92a";
    sha256 = "1mikhffkr4a1yhy36yh70dhgcimcpvdm5mjl5fyni0bpgqrw67dn";
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
