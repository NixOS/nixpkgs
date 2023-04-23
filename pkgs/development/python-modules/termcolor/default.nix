{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-38isPzUHiPI7KUez5s+lpTtjC2EubNiWWgFad2AguZo=";
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
