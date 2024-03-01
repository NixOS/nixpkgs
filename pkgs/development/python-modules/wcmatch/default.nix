{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, bracex
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wAiMf2Qmz2vyflMOK3tzQDGQX35JBHX9g8fFAIq1gbM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    maintainers = with maintainers; [ ];
  };
}
