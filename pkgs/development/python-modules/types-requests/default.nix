{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-urllib3,
  urllib3,
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.33.0.20260712";
  pyproject = true;

  src = fetchPypi {
    pname = "types_requests";
    inherit version;
    hash = "sha256-IUG2erU0pcXNLaxQNPKjX0LmmcW/GF7uYIxSRqBp1/s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    types-urllib3
    urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
