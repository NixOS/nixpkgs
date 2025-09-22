{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
}:

buildPythonPackage rec {
  pname = "undefined";
  version = "0.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xvI3wOPX51GWlLIb1HHcJe48M3nZwjt06/Aqo0nFz/c=";
  };

  nativeBuildInputs = [ flit ];

  pythonImportsCheck = [ "undefined" ];

  meta = with lib; {
    description = "Like `None`, but different in several ways";
    homepage = "https://github.com/Carreau/undefined";
    license = licenses.mit;
    maintainers = [ ];
  };
}
