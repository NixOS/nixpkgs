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
, nixosTests
, fuse3
, cargo
, rustc
, rustPlatform
, makeWrapper
, writeScript
, fuseSupport ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.3.3";


  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-73vgwgBqyRLQ/Tts7bl6DhZMOs8ndIOiCke5tN89Wps=";
  };

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

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ];

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';

  passthru = {
    tests = {
      smoke-test = nixosTests.bcachefs;

      inherit (nixosTests.installer)
        bcachefsSimple
        bcachefsEncrypted
        bcachefsMulti
        bcachefsLinuxTesting
        bcachefsUpgradeToLinuxTesting;
    };

    updateScript = writeScript "update-bcachefs-tools-and-cargo-lock.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      res="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        -sL "https://api.github.com/repos/${finalAttrs.src.owner}/${finalAttrs.src.repo}/tags?per_page=1")"

      version="$(echo $res | jq '.[0].name | split("v") | .[1]' --raw-output)"
      update-source-version ${finalAttrs.pname} "$version" --ignore-same-hash

      curl "https://raw.githubusercontent.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/v$version/rust-src/Cargo.lock" > \
        "$(git rev-parse --show-toplevel)/pkgs/tools/filesystems/bcachefs-tools/Cargo.lock"
    '';
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak Madouura ];
    platforms = platforms.linux;
  };
})
