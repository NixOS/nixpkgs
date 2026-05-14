{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "stop-words";
  version = "2025.11.4";
  pyproject = true;

  src = fetchPypi {
    pname = "stop_words";
    inherit version;
    hash = "sha256-BFkHK1SxHkOm+0xbBb2ofSrM/E8UwWl5dPNzmvD3tD0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "stop_words" ];

  meta = {
    description = "Get list of common stop words in various languages in Python";
    homepage = "https://github.com/Alir3z4/python-stop-words";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ lavafroth ];
  };
}
