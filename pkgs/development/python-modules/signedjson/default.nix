{
  lib,
  buildPythonPackage,
  canonicaljson,
  fetchPypi,
  pynacl,
  pytestCheckHook,
  setuptools-scm,
  unpaddedbase64,
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zZHFavU/Fp7wMsYunEoyktwViGaTMxjQWS40Yts9ZJI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    canonicaljson
    unpaddedbase64
    pynacl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "signedjson" ];

  meta = {
    description = "Sign JSON with Ed25519 signatures";
    homepage = "https://github.com/matrix-org/python-signedjson";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
