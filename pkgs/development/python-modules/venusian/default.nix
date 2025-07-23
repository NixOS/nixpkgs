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
  version = "3.1.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U0+zs1VmkoPrOVRYGTHl0dBx/OYdAp1Y8yGaXjpvDEE=";
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
    maintainers = with maintainers; [ ];
  };
}
