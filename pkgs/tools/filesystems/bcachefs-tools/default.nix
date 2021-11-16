{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, docutils
, libuuid
, libscrypt
, libsodium
, keyutils
, liburcu
, zlib
, libaio
, zstd
, lz4
, python3Packages
, udev
, valgrind
, nixosTests
, fuse3
, fuseSupport ? false
}:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2021-11-06";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "5b84952401146fec9a181a40877352f7faf9ee7b";
    sha256 = "09zs2h3vzqn163v4i9lrvgy9gcjlw24lld7715j3kyyxnc5vav32";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  nativeBuildInputs = [ pkg-config docutils python3Packages.python ];

  buildInputs = [
    libuuid libscrypt libsodium keyutils liburcu zlib libaio
    zstd lz4 python3Packages.pytest udev valgrind
  ] ++ lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  checkInputs = [ valgrind ];

  preCheck = lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.tests = {
    smoke-test = nixosTests.bcachefs;
  };

  meta = with lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno ];
    platforms = platforms.linux;
  };
}
