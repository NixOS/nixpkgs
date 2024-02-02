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
, python3
, fuseSupport ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+KqTiIp9dIJWG2KvgvPwXC7p754XfgvKHjvwjCdbvCs=";
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

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
    "BCACHEFS_FUSE=${toString fuseSupport}"
  ];

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';

  # Tries to install to the 'systemd-minimal' and 'udev' nix installation paths
  installFlags = [
    "PKGCONFIG_SERVICEDIR=$(out)/lib/systemd/system"
    "PKGCONFIG_UDEVDIR=$(out)/lib/udev"
  ];

  postInstall = ''
    substituteInPlace $out/libexec/bcachefsck_all \
      --replace "/usr/bin/python3" "${python3}/bin/python3"
  '';

  passthru = {
    tests = {
      smoke-test = nixosTests.bcachefs;
      inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
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
