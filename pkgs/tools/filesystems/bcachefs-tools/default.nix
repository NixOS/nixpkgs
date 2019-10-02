{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4 }:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2019-09-25";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "db39aa3e1b528db3b9d731c3b054f27411e1e1a9";
    sha256 = "19x7n51yr30dd9rrvji3xk3rij5xd8b86qiym9alpkbbyrz7h956";
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
