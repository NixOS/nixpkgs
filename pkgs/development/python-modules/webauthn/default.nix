{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  asn1crypto,
  cbor2,
  pythonOlder,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webauthn";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "refs/tags/v${version}";
    hash = "sha256-AfQ3lt0WvoThU5kCE7MzhAXwbqmNaCrUqOMWI937hO4=";
  };

  propagatedBuildInputs = [
    asn1crypto
    cbor2
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webauthn" ];

  disabledTests = [
    # TypeError: X509StoreContextError.__init__() missing 1 required...
    "test_throws_on_bad_root_cert"
  ];

  meta = with lib; {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
