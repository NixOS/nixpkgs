{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  cargo,
  hatch-requirements-txt,
  hatch-rs,
  hatch-vcs,
  hatchling,
  pkg-config,
  rustPlatform,
  rustc,
  rust-jemalloc-sys,
  zstd,
  nix-update-script,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-mosaic";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-mosaic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4awnyUSwsmPR7o22oaFmV1RF8AaxqiZWc1p1PEqmdM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZdTSPOsq2V7B2jMVjqaSKxWt98HhCuVgKakjdImdtn4=";
  };

  build-system = [
    cargo
    hatch-requirements-txt
    hatch-rs
    hatch-vcs
    hatchling
    pkg-config
    rustc
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    rust-jemalloc-sys
    zstd
  ];

  pythonImportsCheck = [
    "swh.mosaic"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
      pkgs.zstd
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MOdular Storage of Archived and Indexed Contents from Software Heritage";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-mosaic";
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-mosaic/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
