{
  lib,
  buildPythonPackage,
  requests,
  setuptools,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "Simperium3";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eLgYa+GIaa1f2F6D3VDsK5StT0c9D22fneOYoQEU0Tc=";
  };

  dependencies = [
    requests
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "simperium" ];

  meta = {
    description = "Simperium client library for Python";
    homepage = "https://github.com/Simperium/simperium-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmonsays ];
  };
}
