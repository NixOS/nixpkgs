{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, bracex
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "8.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hsF1ctD3XL87yxoY878vnnKzmpwIybSnTpkeGIKo77M=";
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
