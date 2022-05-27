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
  version = "1.5.2";
  disabled = pythonOlder "3";

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "v${version}";
    sha256 = "sha256-sjl65vx1VthVX6ED3lXXAcn2D5WzzGAINKBjCc10rcs=";
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
    homepage = "https://github.com/benoitc/gunicorn";
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
