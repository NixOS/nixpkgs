{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hatchling,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "stablehash";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5JTa99qew3g2susXV4c/LA038Bb5cHAa/tdAShYybU=";
  };

  build-system = [
    setuptools
    setuptools-scm
    hatchling
  ];

  pythonImportsCheck = [ "stablehash" ];

  meta = {
    description = "Stable hashing library for Python";
    homepage = "https://pypi.org/project/stablehash/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
  };
}
