{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, protobuf
}:
buildPythonPackage rec {
  pname = "vegafusion-embed";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-ZpFF2AjSHJGxTwsM7tl5YP8xF/RGPWm8+nVMoz/U4Ds=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-w7Po6TOnRzZ2uaM9UdBMd/zoeFbLsdy0jqWivk/Apk4=";
  };

  buildAndTestSubdir = "vegafusion-python-embed";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protobuf
  ];

  meta = {
    description = "A Python library that embeds the VegaFusion Runtime and select Connection";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/hex-inc/vegafusion";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
