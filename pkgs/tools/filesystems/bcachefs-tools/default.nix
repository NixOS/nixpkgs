{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils, liburcu, zlib, libaio }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-${version}";
  version = "git";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "a588eb0d9e30dffa4b319a4715c1454ee1d911f1 ";
    sha256 = "1xpiwp6n6jp3zc70i648xpp54cd5yay4si28czn350bxwljbwpsy";
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

