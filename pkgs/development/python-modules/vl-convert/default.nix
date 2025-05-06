{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  callPackage,
  librusty_v8 ? callPackage ./librusty_v8.nix { },
}:
buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    rev = "v${version}";
    hash = "sha256-dmfY05i5nCiM2felvBcSuVyY8G70HhpJP3KrRGQ7wq8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-t952WH6zq7POVvdX3fI7kXXfPiaAXjfsvoqI/aq5Fn0=";
  };

  buildAndTestSubdir = "vl-convert-python";

  RUSTY_V8_ARCHIVE = librusty_v8;

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeBuildInputs = [ protobuf ];

  pythonImportsCheck = [ "vl_convert" ];

  meta = {
    description = "Utilities for converting Vega-Lite specs from the command line and Python";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/vega/vl-convert";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
