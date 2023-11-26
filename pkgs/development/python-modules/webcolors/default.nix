{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, unittestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.13";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wiW2dMg/qSO+k9I1MwzgMANz0CiFzvIyOIE7DVZoMEo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  pythonImportsCheck = [
    "webcolors"
  ];

  meta = with lib; {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = "https://github.com/ubernostrum/webcolors";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
