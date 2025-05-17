{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
}:
buildPythonPackage rec {
  pname = "vegafusion-embed";
  version = "1.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-CItZehy5cPIU38dTOBJA5Q6Xp+4R+6OvyxHXS6L/6xc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-KiXMEFxKSzKzD5D+EkKcs3GFhIhywGqZXyqB1b2GCf8=";
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
