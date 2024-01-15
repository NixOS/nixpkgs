{ lib
, buildPythonPackage
, fetchPypi
, defusedxml
, requests
, packaging
, requests-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tableauserverclient";
  version = "0.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FVJeKt1+qL4XuxFNqhWRtCJu5yEmcP/RLeQQyXndU0c=";
  };

  propagatedBuildInputs = [
    defusedxml
    requests
    packaging
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  # Tests attempt to create some file artifacts and fails
  doCheck = false;

  pythonImportsCheck = [
    "tableauserverclient"
  ];

  meta = with lib; {
    description = "Module for working with the Tableau Server REST API";
    homepage = "https://github.com/tableau/server-client-python";
    changelog = "https://github.com/tableau/server-client-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
