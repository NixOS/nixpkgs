{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2019-08-21";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "72a408f84846fe702b8db4f158b678ee20bbf835";
    sha256 = "0y5700afv1x1i3wnp3g71i3zhyhkwmx79j0irxr63fmg47n0ys1i";
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
