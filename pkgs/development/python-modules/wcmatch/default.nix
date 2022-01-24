{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, bracex }:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "371072912398af61d1e4e78609e18801c6faecd3cb36c54c82556a60abc965db";
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
