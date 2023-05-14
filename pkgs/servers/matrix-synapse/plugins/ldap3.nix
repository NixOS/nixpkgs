{ lib, buildPythonPackage, fetchPypi, ldap3, ldaptor, matrix-synapse, pytestCheckHook, service-identity, setuptools, twisted }:

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s4jZVpNIbu9pra79D9noRGPVL+F7AhSgDvyqZptzy3Q=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ service-identity ldap3 twisted ];

  nativeCheckInputs = [ ldaptor matrix-synapse pytestCheckHook ];

  pythonImportsCheck = [ "ldap_auth_provider" ];

  meta = with lib; {
    description = "LDAP3 auth provider for Synapse";
    homepage = "https://github.com/matrix-org/matrix-synapse-ldap3";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
