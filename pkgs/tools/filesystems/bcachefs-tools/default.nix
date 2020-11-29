{ stdenv, fetchFromGitHub, pkgconfig, attr, libuuid, libscrypt, libsodium, keyutils
, liburcu, zlib, libaio, udev, zstd, lz4, valgrind, python3Packages
, fuseSupport ? false, fuse3 ? null }:

assert fuseSupport -> fuse3 != null;

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "2020-11-17";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "41bec63b265a38dd9fa168b6042ea5bf07135048";
    sha256 = "1y3187kpw1bmnl97isv28k2sw8cmrnsn31a0dw745adwm0n7z6fj";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    libuuid libscrypt libsodium keyutils liburcu zlib libaio
    zstd lz4 python3Packages.pytest udev valgrind
  ] ++ stdenv.lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  checkInputs = [ valgrind ];

  preCheck = stdenv.lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak chiiruno ];
    platforms = platforms.linux;
  };
}
