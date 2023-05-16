{ lib
<<<<<<< HEAD
, asn1crypto
, buildPythonPackage
, certvalidator
, fetchFromGitHub
, mscerts
=======
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, asn1crypto
, certvalidator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, oscrypto
, pyasn1
, pyasn1-modules
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "signify";
<<<<<<< HEAD
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";
=======
  version = "0.4.0";
  disabled = pythonOlder "3.6";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-+UhZF+QYuv8pq/sTu7GDPUrlPNNixFgVZL+L0ulj/ko=";
=======
    rev = "v${version}";
    hash = "sha256-YJc9RIqkEL7dd1ahE4IbxyyZgsZWBDqbXZAvI/nK24M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    asn1crypto
    certvalidator
<<<<<<< HEAD
    mscerts
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    oscrypto
    pyasn1
    pyasn1-modules
  ];

  pythonImportsCheck = [
    "signify"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # chain doesn't validate because end-entitys certificate expired
    # https://github.com/ralphje/signify/issues/27
    "test_revoked_certificate"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
    # No support for pyasn1 > 0.5
    # https://github.com/ralphje/signify/issues/37
    broken = true;
=======
    homepage = "https://github.com/ralphje/signify";
    description = "library that verifies PE Authenticode-signed binaries";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
