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
  version = "1.6.0";
  disabled = pythonOlder "3";

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Ts0zKnQg1EaBNB9xQmzOpEVwDSFwHNjIhEP1jTwEOFI=";
  };

  propagatedBuildInputs = [
    asn1crypto
    cbor2
    pydantic
    pyopenssl
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "webauthn" ];

  meta = with lib; {
    homepage = "https://github.com/duo-labs/py_webauthn";
    description = "Implementation of the WebAuthn API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
