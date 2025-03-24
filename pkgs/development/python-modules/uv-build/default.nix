{
  lib,
  pkgs,
  buildPythonPackage,
  rustPlatform,
  callPackage,
}:

buildPythonPackage {
  pname = "uv-build";
  pyproject = true;

  inherit (pkgs.uv)
    version
    src
    cargoDeps
    cargoBuildFlags
    ;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildAndTestSubdir = "crates/uv-build";

  # $src/.github/workflows/build-binaries.yml#L139
  maturinBuildFlags = [ "--profile=minimal-size" ];

  pythonImportsCheck = [ "uv_build" ];

  # The package has no tests
  doCheck = false;

  # Run the tests of a package built by `uv_build`.
  passthru.tests.built-by-uv = callPackage ./built-by-uv.nix { inherit (pkgs) uv; };

  meta = {
    description = "A minimal build backend for uv";
    inherit (pkgs.uv.meta) homepage changelog license;
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
