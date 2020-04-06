{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2019-10-12";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "6e696ea08703eecd0d1c7b8c520b6f62f06f4f26";
    sha256 = "0m3valm68vc73b4kydlga17fglxa9bldrjaszlladzl5bd0zb967";
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
