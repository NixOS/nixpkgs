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
  version = "unstable-2021-09-22";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "9942fc82d43baf261342d2550cd22609bf4f81b1";
    sha256 = "0dqr0cghzggy9xk90bmw27i7ni83lrsnfrvbyvh11k9fv3211wnk";
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
