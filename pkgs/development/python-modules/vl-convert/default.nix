{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  cmakeMinimal,
  protobuf,
  fetchurl,
  stdenv,
  callPackage,
  librusty_v8 ? callPackage ./librusty_v8.nix { },
}:
buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    rev = "v${version}";
    hash = "sha256-xZpgwV4ZM3AhtbLMio62C0OIztECGKgJOdOAEYArwwg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jqHh3wpb5Z3mJmsjbWBon/PHRsE0zUqZDpEIIVWQgpc=";
  };

  buildAndTestSubdir = "vl-convert-python";

  RUSTY_V8_ARCHIVE = librusty_v8;

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeBuildInputs = with rustPlatform; [ protobuf ];

  pythonImportsCheck = [ "vl_convert" ];

  meta = {
    description = "Utilities for converting Vega-Lite specs from the command line and Python";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/vega/vl-convert";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
