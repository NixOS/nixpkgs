{
  lib,
  buildPythonPackage,
  fetchPypi,
  h11,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uGiF3PKU4VIEkZlQ9mbgb/xsfBFMqQCwYNbhYpNSgpQ=";
  };

  propagatedBuildInputs = [ h11 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wsproto" ];

  meta = {
    description = "Pure Python, pure state-machine WebSocket implementation";
    homepage = "https://github.com/python-hyper/wsproto/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
