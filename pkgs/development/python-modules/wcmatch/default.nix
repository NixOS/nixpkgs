{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, bracex
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uk/FVY+JRr8f/HA0sFuBTYJdaUESSZyGA14OTTmLamc=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ bracex ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "TestTilde"
  ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = with lib; {
    description = "Wilcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
