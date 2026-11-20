{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "vtracer";
  version = "0.6.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9/OZQ9H8jp3IL1NgpA6UGq9MkWbY3zDD9qLajMId/FI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-pMI73XXmFEcOwjs2/qmxI6oTd84OrVAUiLG2WZVQ0Gk=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  pythonImportsCheck = [ "vtracer" ];

  meta = {
    description = "Raster to vector graphics converter";
    homepage = "https://github.com/visioncortex/vtracer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
}
