{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pytest-cov
, setuptools
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

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A library for deferring decorator actions";
    homepage = "https://pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
