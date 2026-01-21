{
  lib,
  buildPythonPackage,
  fetchPypi,
  h11,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rVZfJuy5JYij5DvD2WFk3oTNmQJIKxMNDduqlmSoUGU=";
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
