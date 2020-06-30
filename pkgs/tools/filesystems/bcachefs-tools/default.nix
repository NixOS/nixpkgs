{ stdenv, fetchFromGitHub, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, libudev, zstd, lz4, valgrind, python3Packages
, fuseSupport ? false, fuse3 ? null }:

assert fuseSupport -> fuse3 != null;

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2020-05-23";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "bae7a9ae8da70447bf62b764dfd124bea9161196";
    sha256 = "02sbbz2k1zfwiaf185z3i3jlxj29dzqinwz2n0ykf6rvr7yd18q1";
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
    zstd lz4 python3Packages.pytest libudev
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
