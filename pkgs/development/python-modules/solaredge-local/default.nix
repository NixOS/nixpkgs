{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  uplink,
  uplink-protobuf,
}:

buildPythonPackage rec {
  pname = "solaredge-local";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    pname = "solaredge_local";
    inherit version;
    hash = "sha256-tGUr4zlMdyJqRyFAs7INiH5rJYPmu7qoaImg4dzW5rk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    uplink
    uplink-protobuf
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "solaredge_local" ];

  meta = {
    description = "API wrapper to communicate locally with SolarEdge Inverters";
    homepage = "https://github.com/drobtravels/solaredge-local";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
