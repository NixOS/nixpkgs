{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-10-12";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "55fbb25501330038e1714905b9ddeb25d875c11c";
    sha256 = "0cwzbyf133jc0fkc8nmjcvv3wmglqhyxda1hh10hgxrbq5vm39wx";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ attr libuuid libscrypt libsodium keyutils liburcu zlib libaio zstd lz4 ];
  installFlags = [ "PREFIX=$(out)" ];
  
  preInstall = ''
    sed -i \
      "s,INITRAMFS_DIR=/etc/initramfs-tools,INITRAMFS_DIR=$out/etc/initramfs-tools,g" Makefile
  '';

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = https://bcachefs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno ];
    platforms = platforms.linux;
  };
}
