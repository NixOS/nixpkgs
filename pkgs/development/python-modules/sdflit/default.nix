{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
}:

let
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "yzx9";
    repo = "sdflit";
    tag = "v${version}";
    hash = "sha256-Ze3J5Dp+TskhIiGP6kMK3AIHLnhVBuEaKJokccIr+SM=";
  };
in
buildPythonPackage {
  pname = "sdflit";
  inherit version src;
  pyproject = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-CrMe5DuO9sQZZ50Hy+av4nF4gbOe296zSWJfJ8th7zs=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "sdflit"
  ];

  meta = {
    description = "Fast and Robust Signed Distance Function Library";
    homepage = "https://github.com/yzx9/sdflit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
