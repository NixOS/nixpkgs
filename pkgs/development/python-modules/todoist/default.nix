{ lib
, fetchPypi
, buildPythonPackage
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AFRKA5VRD6jyiguZYP7WOQOWqHq1GjUzbuez0f1070U=";
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "todoist"
  ];

  meta = with lib; {
    description = "The official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
