{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  minikerberos,
}:

buildPythonPackage (finalAttrs: {
  pname = "winsspi";
  version = "0.0.11";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-AXC6SJ+iWPGqTmdgoWKEbD8tDUUcg2aD609hO2bdQfM=";
  };

  build-system = [ setuptools ];

  dependencies = [ minikerberos ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "winsspi" ];

  meta = {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winsspi";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
