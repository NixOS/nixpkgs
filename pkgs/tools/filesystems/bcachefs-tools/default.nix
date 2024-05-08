{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libuuid,
  libsodium,
  keyutils,
  liburcu,
  zlib,
  libaio,
  zstd,
  lz4,
  attr,
  udev,
  nixosTests,
  fuse3,
  cargo,
  rustc,
  rustPlatform,
  makeWrapper,
  writeScript,
  python3,
  fuseSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nHT18bADESDBHoo9P+J3gGc092hRYs2vaWupgqlkvaA=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
  ];

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

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    hash = "sha256-RsRz/nb8L+pL1U4l6RnvqeDFddPvcBFH4wdV7G60pxA=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ] ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  # FIXME: Try enabling this once the default linux kernel is at least 6.7
  doCheck = false; # needs bcachefs module loaded on builder

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

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
    '';
  };

  enableParallelBuilding = true;

  meta = {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      davidak
      johnrtitor
      Madouura
    ];
    platforms = lib.platforms.linux;
  };
})
