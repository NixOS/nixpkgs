{
  lib,
  buildPythonPackage,
  fetchPypi,
  minikerberos,
}:

buildPythonPackage rec {
  pname = "winsspi";
  version = "0.0.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AXC6SJ+iWPGqTmdgoWKEbD8tDUUcg2aD609hO2bdQfM=";
  };

  propagatedBuildInputs = [ minikerberos ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "winsspi" ];

  meta = {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winsspi";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
