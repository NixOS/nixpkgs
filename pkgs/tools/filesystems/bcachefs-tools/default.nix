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
, coreutils
, python3Packages
, util-linux
, udev
, valgrind
, nixosTests
, makeWrapper
, getopt
, fuse3
, fuseSupport ? false
, rustPlatform
}:

stdenv.mkDerivation rec {
  pname = "bcachefs-tools";
  version = "unstable-2023-05-02";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "6b1f79d5df9f2735192ed1a40c711cf131d4f43e";
    hash = "sha256-MZr+RQ45KMWARzdbYmurXc1k7DC44hAKO0WaT5Fr5pQ=";
  };

  cargoRoot = "rust-src";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/${cargoRoot}/Cargo.lock";
    outputHashes = {
     "bindgen-0.64.0" = "sha256-GNG8as33HLRYJGYe0nw6qBzq86aHiGonyynEM7gaEE4=";
    };
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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    bindgenHook
    rust.cargo
    rust.rustc
  ]);

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

  # this wrap is needed for mount -t bcachefs to work
  postFixup = ''
    wrapProgram $out/bin/mount.bcachefs \
      --prefix PATH : ${lib.makeBinPath [ coreutils getopt util-linux ]}
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
