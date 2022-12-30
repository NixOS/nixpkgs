{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z87iAJrcZEnGUPa8873u0AyLpTqM2lNiczxT4KOftws=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [
    "termcolor"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Termcolor";
    homepage = "https://pypi.python.org/pypi/termcolor";
    license = licenses.mit;
  };

}
