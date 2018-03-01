{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium
, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-02-08";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "fc96071b58c28ea492103e7649c0efd5bab50ead";
    sha256 = "0a2sxkz0mkmvb5g4k2v8g2c89dj29haw9bd3bpwk0dsfkjif92vy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ attr libuuid libscrypt libsodium keyutils liburcu zlib libaio ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = https://bcachefs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}
