{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  asgiref,
  psutil,
  urllib3,
  certifi,
  wrapt,
}:

buildPythonPackage rec {
  pname = "scout-apm";
  version = "3.5.3";
  pyproject = true;

  src = fetchPypi {
    pname = "scout_apm";
    inherit version;
    hash = "sha256-VOV16V9fmpjAlZigkuwD/I11dpB8U8XiBjKj8F4QNHk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    certifi
    psutil
    urllib3
    wrapt
  ];

  # The PyPI sdist doesn't ship a tests/ directory at all.
  doCheck = false;

  pythonImportsCheck = [ "scout_apm" ];

  meta = {
    description = "Scout Application Performance Monitoring Agent";
    homepage = "https://github.com/scoutapp/scout_apm_python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
