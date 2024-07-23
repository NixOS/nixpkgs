{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "71.1.0.20240723";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ipNJA4x+ItiObF2cZwWzR7IpMEJBFKRSwXEomehRMf8=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
