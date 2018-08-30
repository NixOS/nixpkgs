{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation rec {
  name = "bcachefs-tools-unstable-2018-07-21";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "cecf7e05e151499a3e96dc05f97f37c14162e94b";
    sha256 = "18vmyrjwza1iv0apkykbqsnnic5lrqlwfsrj85pgrpwzii36i8i0";
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
