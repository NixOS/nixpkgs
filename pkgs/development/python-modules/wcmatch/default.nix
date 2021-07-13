{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, bracex }:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d54ddb506c90b5a5bba3a96a1cfb0bb07127909e19046a71d689ddfb18c3617";
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
