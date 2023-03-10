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
, util-linux
, udev
, valgrind
, nixosTests
, makeWrapper
, getopt
, fuse3
, fuseSupport ? false
}:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2023-01-31";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "3c39b422acd3346321185be0ce263809e2a9a23f";
    hash = "sha256-2ci/m4JfodLiPoWfP+QCEqlk0k48zq3mKb8Pdrtln0o=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  nativeBuildInputs = [
    pkg-config docutils python3Packages.python makeWrapper
  ];

  buildInputs = [
    libuuid libscrypt libsodium keyutils liburcu zlib libaio
    zstd lz4 python3Packages.pytest udev valgrind
  ] ++ lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  nativeCheckInputs = [ valgrind ];

  preCheck = lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  # this symlink is needed for mount -t bcachefs to work
  postFixup = ''
    ln -s $out/bin/mount.bcachefs.sh $out/bin/mount.bcachefs
    wrapProgram $out/bin/mount.bcachefs.sh \
      --prefix PATH : ${lib.makeBinPath [ getopt util-linux ]}
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
