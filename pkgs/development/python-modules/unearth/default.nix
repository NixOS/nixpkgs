{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
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
  version = "0.15.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YyTlF1HVeDYqlhzYosYmqVCzlFFscdhTSNBv9Z8/vhQ=";
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

  meta = with lib; {
    description = "A utility to fetch and download Python packages";
    mainProgram = "unearth";
    homepage = "https://github.com/frostming/unearth";
    changelog = "https://github.com/frostming/unearth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ betaboon ];
  };
}
