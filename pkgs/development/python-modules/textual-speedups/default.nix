{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "textual-speedups";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = "textual-speedups";
    tag = "v${version}";
    hash = "sha256-zsDA8qPpeiOlmL18p4pItEgXQjgrQEBVRJazrGJT9Bw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Bz4ocEziOlOX4z5F9EDry99YofeGyxL/6OTIf/WEgK4=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "textual_speedups" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Optional Rust speedups for Textual";
    homepage = "https://github.com/willmcgugan/textual-speedups";
    # No license (yet?)
    # https://github.com/willmcgugan/textual-speedups/issues/2
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
