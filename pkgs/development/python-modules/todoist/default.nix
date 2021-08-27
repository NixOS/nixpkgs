{ lib, fetchPypi, buildPythonPackage
, requests, fetchpatch, pythonOlder, typing
}:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AFRKA5VRD6jyiguZYP7WOQOWqHq1GjUzbuez0f1070U=";
  };

  propagatedBuildInputs = [ requests ] ++ lib.optional (pythonOlder "3.5") typing;

  meta = with lib; {
    description = "The official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
