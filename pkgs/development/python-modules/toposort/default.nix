{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v7tHnFPQppbqdAJgH05pPJewNng3yImLxkca38o3pr0=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "toposort" ];

  meta = {
    description = "Topological sort algorithm";
    homepage = "https://pypi.python.org/pypi/toposort/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
