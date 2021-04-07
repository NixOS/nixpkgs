{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, bracex }:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efda751de15201b395b6d6e64e6ae3b6b03dc502a64c3c908aa5cad14c27eee5";
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
