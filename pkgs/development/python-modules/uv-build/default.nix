{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "uv-build";
  version = "0.11.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-/mTH2hojC+l0yxn+LEAIj8FTA/nWKIPZ7uLMVJxebw4=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-FvLl32JfIq5a1NnLtnFJyy5T+vkcOD+qfQLDy6NYhHg=";
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
