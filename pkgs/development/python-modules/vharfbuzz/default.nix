{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fonttools,
  uharfbuzz,
}:

buildPythonPackage rec {
  pname = "vharfbuzz";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zFVw8Nxh7cRJNk/S7D3uiIGShBMiZ/JeuSdX4hN94kc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    uharfbuzz
  ];

  # Package has no tests.
  doCheck = false;

  pythonImportsCheck = [ "vharfbuzz" ];

  meta = {
    description = "Utility for removing hinting data from TrueType and OpenType fonts";
    homepage = "https://github.com/source-foundry/dehinter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
