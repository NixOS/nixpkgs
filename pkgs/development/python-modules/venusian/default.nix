{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "3.1.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-63LNym8xOaFdyA+cldPBD4pUoLqIHu744uxbQtPuOpU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Library for deferring decorator actions";
    homepage = "https://pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
