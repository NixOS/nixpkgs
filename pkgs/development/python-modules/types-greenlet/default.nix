{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-greenlet";
  version = "3.2.0.20250417";
  pyproject = true;

  src = fetchPypi {
    pname = "types_greenlet";
    inherit version;
    hash = "sha256-6wBq/PKB7FdWp1wf1KbIp75dDMCbLoLEhWx2R2DPoOM=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "greenlet-stubs" ];

  meta = {
    description = "Typing stubs for greenlet";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
