{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  buildPythonPackage,
  rustPlatform,
  callPackage,
  pkg-config,
  pkgsHostTarget,
}:

buildPythonPackage (finalAttrs: {
  pname = "uv-build";
  version = "0.12.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-tKdqciPQnteeTqkXtWY8mliWUDv5gMdU8x0UPadQZlQ=";
  };

  # Add the missing FIEMAP ioctl constants for loongarch64
  # https://github.com/sunfishcode/linux-raw-sys/pull/195
  patches = lib.optionals stdenv.hostPlatform.isLoongArch64 [
    (fetchurl {
      name = "loongarch64-fiemap.patch";
      url = "https://github.com/lcpu-club/loongarch-packages/raw/28165d5d4f00d1dfb6194c7d4f1f37e9c2ba56b2/uv/loongarch64-fiemap.patch";
      hash = "sha256-owRf+JtH/4GKsUFB2UwKCvXhLUZJ3vI2Zeywhz4tgbE=";
    })
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];

  buildInputs = [
    pkgsHostTarget.zstd
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-27NzA/YXYbcGO6ehXP9OgvgLJQG/YP/I+eeflLmzxRQ=";
  };

  buildAndTestSubdir = "crates/uv-build";

  # $src/.github/workflows/build-binaries.yml#L139
  maturinBuildProfile = "minimal-size";

  pythonImportsCheck = [ "uv_build" ];

  # The package has no tests
  doCheck = false;

  # Run the tests of a package built by `uv_build`.
  passthru = {
    tests.built-by-uv = callPackage ./built-by-uv.nix { };

    # updateScript is not needed here, as updating is done on staging
  };

  meta = {
    changelog = "https://github.com/astral-sh/uv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Minimal build backend for uv";
    homepage = "https://docs.astral.sh/uv/reference/settings/#build-backend";
    inherit (pkgs.uv.meta) license;
    maintainers = with lib.maintainers; [ bengsparks ];
  };
})
