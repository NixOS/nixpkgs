<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, ldap3
, ldaptor
, matrix-synapse-unwrapped
, pytestCheckHook
, service-identity
, setuptools
, twisted
}:
=======
{ lib, buildPythonPackage, fetchPypi, ldap3, ldaptor, matrix-synapse, pytestCheckHook, service-identity, setuptools, twisted }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "matrix-synapse-ldap3";
  version = "0.2.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s4jZVpNIbu9pra79D9noRGPVL+F7AhSgDvyqZptzy3Q=";
  };

<<<<<<< HEAD
  patches = [
    # add support to read bind_password from file
    (fetchpatch {
      url = "https://github.com/matrix-org/matrix-synapse-ldap3/commit/c65e8cbd27a5cd935ce12e7c4b92143cdf795c86.patch";
      sha256 = "sha256-0g150TW631cuupSRECXL9A261nj45HclDkHBUbKT7jE=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ service-identity ldap3 twisted ];

<<<<<<< HEAD
  nativeCheckInputs = [ ldaptor matrix-synapse-unwrapped pytestCheckHook ];
=======
  nativeCheckInputs = [ ldaptor matrix-synapse pytestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "ldap_auth_provider" ];

  meta = with lib; {
    description = "LDAP3 auth provider for Synapse";
    homepage = "https://github.com/matrix-org/matrix-synapse-ldap3";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
