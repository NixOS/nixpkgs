{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  unittestCheckHook,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "24.11.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7LPXaPMiAq93BHe4tl8xj6T1ZsIpSGc6l3sA1YndgPY=";
  };

  build-system = [ pdm-backend ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "webcolors" ];

  meta = with lib; {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = "https://github.com/ubernostrum/webcolors";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
