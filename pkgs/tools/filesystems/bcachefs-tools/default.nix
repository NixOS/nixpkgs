{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2017-08-28";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "b1814f2dd0c6b61a12a2ebb67a13d406d126b227";
    sha256 = "05ba1h09rrqj6vjr3q37ybca3nbrmnifmffdyk83622l28fpv350";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ attr libuuid libscrypt libsodium keyutils liburcu zlib libaio ];

  preConfigure = ''
    substituteInPlace cmd_migrate.c --replace /usr/include/dirent.h ${stdenv.lib.getDev stdenv.cc.libc}/include/dirent.h
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = http://bcachefs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}

