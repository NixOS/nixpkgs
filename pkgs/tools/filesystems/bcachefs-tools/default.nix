{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium
, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-02-05";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "99adc23cf6260a8e5b237f498119ee163d8f71f6";
    sha256 = "105i8h4p2ix03mcpcdn44hxzabp5ykqni0xd027d2yddx0vagn4q";
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
