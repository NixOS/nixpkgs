{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2016-05-13";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "565b4a74d6c25c78b0d2b82d9529595fc6269308";
    sha256 = "1wnis26hq67vxqkxzck6wm6caq4c1rfmy9blmmgkzlhdd2nzisbx";
  };

  buildInputs = [ pkgconfig attr libuuid libscrypt libsodium keyutils liburcu zlib libaio ];

  preConfigure = ''
    substituteInPlace cmd_migrate.c --replace /usr/include/dirent.h ${stdenv.glibc.dev}/include/dirent.h
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "http://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}

