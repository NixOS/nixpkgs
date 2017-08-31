{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2017-06-14";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "851e945db88322153df06bd8a9db506217a6029f";
    sha256 = "0dqwrrsxiszvdi060krxlvdvk1v33ac1jmi9rx6jvhlavs3fxl4m";
  };

  buildInputs = [ pkgconfig attr libuuid libscrypt libsodium keyutils liburcu zlib libaio ];

  preConfigure = ''
    substituteInPlace cmd_migrate.c --replace /usr/include/dirent.h ${stdenv.glibc.dev}/include/dirent.h
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

