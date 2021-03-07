{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, bracex }:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e6CRkflYLoLYZIKb37qwLfRuJqRqME5Xx/5WUvB/KXo=";
  };

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
