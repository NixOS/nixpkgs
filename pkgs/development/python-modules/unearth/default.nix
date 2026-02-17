{
  lib,
  buildPythonPackage,
  fetchPypi,
  packaging,
  pdm-backend,
  httpx,
  flask,
  pytest-httpserver,
  pytest-mock,
  pytestCheckHook,
  requests-wsgi-adapter,
  trustme,
}:

buildPythonPackage rec {
  pname = "unearth";
  version = "0.17.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oZ4cAuZLQFGNCIB5x0FvxBtFpki4GkEoqsAllyNO5ro=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    packaging
    httpx
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    flask
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    requests-wsgi-adapter
    trustme
  ];

  pythonImportsCheck = [ "unearth" ];

  meta = {
    description = "Utility to fetch and download Python packages";
    mainProgram = "unearth";
    homepage = "https://github.com/frostming/unearth";
    changelog = "https://github.com/frostming/unearth/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ betaboon ];
  };
}
