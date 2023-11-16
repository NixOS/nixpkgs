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
  version = "1.3.1";
in
stdenv.mkDerivation {
  pname = "bcachefs-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "v${version}";
    hash = "sha256-4TmH6YOW6ktISVA6RLo7JRl8/SnRzGMrdbyCr+mDkqY=";
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
    "VERSION=${version}"
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
