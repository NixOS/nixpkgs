{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
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
, util-linux
, coreutils
, gawk
}:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2022-09-28";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "99caca2c70f312c4a2504a7e7a9c92a91426d885";
    sha256 = "sha256-9bFTBFkQq8SvhYa9K4+MH2zvKZviNaq0sFWoeGgch7g=";
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
    zstd lz4 python3Packages.pytest udev valgrind makeWrapper
  ] ++ lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  checkInputs = [ valgrind ];

  preCheck = lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  postFixup = ''
    wrapProgram $out/bin/mount.bcachefs.sh \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ util-linux coreutils gawk ]}"
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.tests = {
    smoke-test = nixosTests.bcachefs;
    inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak Madouura ];
    platforms = platforms.linux;
  };
}
