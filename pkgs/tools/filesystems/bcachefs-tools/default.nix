{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libuuid
, libsodium
, keyutils
, liburcu
, zlib
, libaio
, zstd
, lz4
, attr
, udev
, valgrind
, nixosTests
, fuse3
, cargo
, rustc
, coreutils
, rustPlatform
, makeWrapper
, fuseSupport ? false
}:
let
  rev = "cfa816bf3f823a3bedfedd8e214ea929c5c755fe";
in stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2023-06-28";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    inherit rev;
    hash = "sha256-XgXUwyZV5N8buYTuiu1Y1ZU3uHXjZ/OZ1kbZ9d6Rt5I=";
  };

  # errors on fsck_err function. Maybe miss-detection?
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
  ];

  cargoRoot = "rust-src";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bindgen-0.64.0" = "sha256-GNG8as33HLRYJGYe0nw6qBzq86aHiGonyynEM7gaEE4=";
    };
  };

  buildInputs = [
    libaio
    keyutils
    lz4

    libsodium
    liburcu
    libuuid
    zstd
    zlib
    attr
    udev
  ] ++ lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  nativeCheckInputs = [ valgrind ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${lib.strings.substring 0 7 rev}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ];

  preCheck = lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

  passthru.tests = {
    smoke-test = nixosTests.bcachefs;
    inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
  };

  postFixup = ''
    wrapProgram $out/bin/mount.bcachefs \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak Madouura ];
    platforms = platforms.linux;
  };
}
