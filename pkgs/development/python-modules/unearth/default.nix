{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cached-property
, packaging
, pdm-backend
, requests
, flask
, pytest-httpserver
, pytestCheckHook
, requests-wsgi-adapter
, trustme
}:

buildPythonPackage rec {
  pname = "unearth";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-883fuUrA+GX7z5ZCMVVu9xgwEDecALASBVF6UMeKGG0=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    packaging
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    flask
    pytest-httpserver
    pytestCheckHook
    requests-wsgi-adapter
    trustme
  ];

  pythonImportsCheck = [
    "unearth"
  ];

  meta = with lib; {
    description = "A utility to fetch and download Python packages";
    mainProgram = "unearth";
    homepage = "https://github.com/frostming/unearth";
    changelog = "https://github.com/frostming/unearth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ betaboon ];
  };
}
