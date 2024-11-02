{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7wwfAg2fEqUVxOxlwHkgpwJhOvytHb/cO87CVrbAcrM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "waitress" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTests = [
    # access to socket
    "test_service_port"
  ];

  meta = with lib; {
    homepage = "https://github.com/Pylons/waitress";
    description = "Waitress WSGI server";
    mainProgram = "waitress-serve";
    license = licenses.zpl21;
    maintainers = with maintainers; [ domenkozar ];
  };
}
