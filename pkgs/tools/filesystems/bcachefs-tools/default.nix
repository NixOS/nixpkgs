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
  version = "unstable-2021-10-01";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "37850436dd7dfbe67738749c4d4a2506ffff1ec3";
    sha256 = "040vgxrimahmfs9rhlggfwg0bzl7h9j2ksx3563rh63asjwlhnhi";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools" \
      --replace "doc/macro2rst.py" "python3 doc/macro2rst.py"
  '';

  nativeBuildInputs = [ pkg-config docutils ];

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
    platforms = [ "x86_64-linux" ]; # does not build on aarch64, see https://github.com/koverstreet/bcachefs-tools/issues/39
  };
}
