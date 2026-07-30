{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
}:

let
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "yzx9";
    repo = "sdflit";
    tag = "v${version}";
    hash = "sha256-9x/EnFCWhGu1zlLLz6D084PduS9ReQqdeRMblmw0g/s=";
  };
in
buildPythonPackage {
  pname = "sdflit";
  inherit version src;
  pyproject = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Bz4HfpC+qNWWV3KgLW8L+4d5odmbYNRvdMjdMBy6qIQ=";
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
