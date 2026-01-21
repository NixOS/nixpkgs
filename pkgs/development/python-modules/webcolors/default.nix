{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "25.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YquuhlBPZtD2NkwqhSDeSgxHuAwD/DpfGBX+2+98Gb8=";
  };

  build-system = [ pdm-backend ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "webcolors" ];

  meta = {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = "https://github.com/ubernostrum/webcolors";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
