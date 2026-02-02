{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "stockfish";
  version = "3.28.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h2QSfABDSqhbf8ocBkgA5+qQe7NibM1LWD8OkRsBQHA=";
  };

  patches = [ ./setup.patch ];

  build-system = [
    setuptools
    wheel
  ];

  # Tests fail due to stockfish version incompatibility
  # https://github.com/py-stockfish/stockfish/issues/17
  doCheck = false;

  pythonImportsCheck = [ "stockfish" ];

  meta = {
    description = "Integrates the Stockfish chess engine with Python";
    homepage = "https://github.com/py-stockfish/stockfish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamerrq ];
  };
}
