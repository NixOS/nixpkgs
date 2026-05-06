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
  version = "0.11.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-wu9EA3z/qj29lfSj8wKE4p8XEAJQakQTg2AK8I/64us=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ygGRoZgD88Q2EkN0U4SDTwya96Ds3Pqy3Llj8cjGwnY=";
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
