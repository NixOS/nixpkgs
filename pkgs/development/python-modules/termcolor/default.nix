{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tbCPaJN/E4/pL2wIm5nx4toK5WxSt4v3B1/ZVCD9mlo=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [
    "termcolor"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Termcolor";
    homepage = "https://pypi.python.org/pypi/termcolor";
    license = licenses.mit;
  };

}
