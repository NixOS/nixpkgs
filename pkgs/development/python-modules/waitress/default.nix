{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "3.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aCqq8q8MRK2kq/tw3tNjk/DjB/SrlFaiFc4AILrvwx8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "waitress" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  disabledTests = [
    # access to socket
    "test_service_port"
  ];

  # Tests use sockets
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://github.com/Pylons/waitress";
    description = "Waitress WSGI server";
    mainProgram = "waitress-serve";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
