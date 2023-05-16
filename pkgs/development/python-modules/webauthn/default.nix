{ lib
, buildPythonPackage
, fetchFromGitHub
, asn1crypto
, cbor2
, pythonOlder
, pydantic
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "webauthn";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ZfHFyjdZeKuKX/aokhB6L93HbBFnlrvuJZ2V4uRmNck=";
=======
    hash = "sha256-ivPLS+kh/H8qLojgc5qh1ndPzSZbzbnm9E+LQGq8+Xs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    asn1crypto
    cbor2
    pydantic
    pyopenssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "webauthn"
  ];

  disabledTests = [
    # TypeError: X509StoreContextError.__init__() missing 1 required...
    "test_throws_on_bad_root_cert"
  ];

  meta = with lib; {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
