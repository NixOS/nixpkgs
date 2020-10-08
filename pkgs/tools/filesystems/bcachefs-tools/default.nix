{ stdenv, fetchFromGitHub, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, udev, zstd, lz4, valgrind, python3Packages
, fuseSupport ? false, fuse3 ? null }:

assert fuseSupport -> fuse3 != null;

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2020-08-25";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "487ddeb03c574e902c5b749b4307e87e2150976a";
    sha256 = "1pcid7apxmbl9dyvxcqby3k489wi69k8pl596ddzmkw5gmhgvgid";
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
    zstd lz4 python3Packages.pytest udev valgrind
  ] ++ stdenv.lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder

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
