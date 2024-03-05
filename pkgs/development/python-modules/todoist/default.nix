{ lib
, fetchPypi
, buildPythonPackage
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rkg6eSLiQe8DZaVu2DEnlKLe8RLkRwKmpw+TaYj+lp0=";
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
