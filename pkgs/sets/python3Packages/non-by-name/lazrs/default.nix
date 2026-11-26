{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
  version = "0.9.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-al3+uiTaVURYBxL2h88lOfeXCSuqZh9L8Feh/6PIh0Y=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
    hash = "sha256-cv3MzDsejgJGLVI3MQIVMFERNa1JQbLKGotPhFXi4do=";
  };

  pythonImportsCheck = [ "lazrs" ];

  meta = {
    description = "Python bindings for laz-rs";
    homepage = "https://github.com/laz-rs/laz-rs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nh2
      chpatrick
    ];
    teams = [ lib.teams.geospatial ];
  };
}
