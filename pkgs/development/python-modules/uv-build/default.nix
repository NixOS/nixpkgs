{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  callPackage,
}:

buildPythonPackage rec {
  pname = "uv-build";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = version;
    hash = "sha256-XpWBgFxBflyqsla0K83j/3aBgq5ccedQTa5PoaYs9f0=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-9SEUnud2gu64+trX87GhpXzTlBaB/DLrXLjoZbGL0f4=";
  };

  buildAndTestSubdir = "crates/uv-build";

  # $src/.github/workflows/build-binaries.yml#L139
  maturinBuildProfile = "minimal-size";

  pythonImportsCheck = [ "uv_build" ];

  # The package has no tests
  doCheck = false;

  # Run the tests of a package built by `uv_build`.
  passthru = {
    tests.built-by-uv = callPackage ./built-by-uv.nix { inherit (pkgs) uv; };

    # updateScript is not needed here, as updating is done on staging
  };

  meta = {
    description = "Minimal build backend for uv";
    homepage = "https://docs.astral.sh/uv/reference/settings/#build-backend";
    inherit (pkgs.uv.meta) changelog license;
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
