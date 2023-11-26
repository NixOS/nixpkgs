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
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    rev = "v${version}";
    hash = "sha256-xdAVVYIqwJWZ+sBJUz2HL1AvYUJl8LD4iOV3Lf8c3E8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-MOwfD5k87LiLcMfGxA6liZAmFbqtsp9qYeh/du+eclE=";
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
