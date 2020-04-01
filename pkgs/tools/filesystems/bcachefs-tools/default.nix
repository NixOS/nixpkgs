{ stdenv, fetchgit, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, zstd, lz4, valgrind, python3Packages
, fuseSupport ? false, fuse3 ? null }:

assert fuseSupport -> fuse3 != null;

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2020-04-04";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "5d6e237b728cfb7c3bf2cb1a613e64bdecbd740d";
    sha256 = "1syym9k3njb0bk2mg6832cbf6r42z6y8b6hjv7dg4gmv2h7v7l7g";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libuuid libscrypt libsodium keyutils liburcu zlib libaio
    zstd lz4 python3Packages.pytest
  ] ++ stdenv.lib.optional fuseSupport fuse3;

  doCheck = true;

  checkFlags = [
    "BCACHEFS_TEST_USE_VALGRIND=no"
  ];

  checkInputs = [
    valgrind
  ];

  preCheck = stdenv.lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno ];
    platforms = platforms.linux;
  };
}
