{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2019-10-01";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "7f69c4161c31b8f43723a9ccad1a9a358f4e2e70";
    sha256 = "0v4b8h99cd434v349y8vmhj2igf0ryky7svd20ar1fr7da580kvj";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ attr libuuid libscrypt libsodium keyutils liburcu zlib libaio zstd lz4 ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  preInstall = ''
    substituteInPlace Makefile \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = https://bcachefs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno ];
    platforms = platforms.linux;
  };
}
