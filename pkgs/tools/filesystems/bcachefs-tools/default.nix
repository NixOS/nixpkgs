{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-08-22";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "ebf97e8e01a8e76ff4bec23f29106430852c3081";
    sha256 = "0f2ycin0gmi1a4fm7qln0c10zn451gljfbc2piy1fm768xqqrmld";
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
