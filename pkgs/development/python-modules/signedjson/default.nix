{ lib
, buildPythonPackage
, canonicaljson
, fetchPypi
, importlib-metadata
, pynacl
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
, unpaddedbase64
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zZHFavU/Fp7wMsYunEoyktwViGaTMxjQWS40Yts9ZJI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    canonicaljson
    unpaddedbase64
    pynacl
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "signedjson"
  ];

  meta = with lib; {
    description = "Sign JSON with Ed25519 signatures";
    homepage = "https://github.com/matrix-org/python-signedjson";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
