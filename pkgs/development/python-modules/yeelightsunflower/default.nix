{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yeelightsunflower";
  version = "0.0.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l4Rl6WSCK68/XBwCndonNu3kePDXfSs/uIXaCkrIT7g==";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "yeelightsunflower" ];

  meta = {
    description = "Python package for interacting with Yeelight Sunflower bulbs";
    homepage = "https://github.com/lindsaymarkward/python-yeelight-sunflower";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
