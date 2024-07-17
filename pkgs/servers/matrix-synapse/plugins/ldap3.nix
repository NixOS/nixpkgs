{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  ldap3,
  ldaptor,
  matrix-synapse-unwrapped,
  pytestCheckHook,
  service-identity,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s4jZVpNIbu9pra79D9noRGPVL+F7AhSgDvyqZptzy3Q=";
  };

  patches = [
    # add support to read bind_password from file
    (fetchpatch {
      url = "https://github.com/matrix-org/matrix-synapse-ldap3/commit/c65e8cbd27a5cd935ce12e7c4b92143cdf795c86.patch";
      sha256 = "sha256-0g150TW631cuupSRECXL9A261nj45HclDkHBUbKT7jE=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    service-identity
    ldap3
    twisted
  ];

  nativeCheckInputs = [
    ldaptor
    matrix-synapse-unwrapped
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ldap_auth_provider" ];

  meta = with lib; {
    description = "LDAP3 auth provider for Synapse";
    homepage = "https://github.com/matrix-org/matrix-synapse-ldap3";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
  };
}
