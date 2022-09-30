{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, bracex
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sfBCqJnqTEWLcyHaG14zMePg7HgVg0NN4TAZRs6tuUM=";
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
