{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "24.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CLB68oagG80w1YOnrK32KVg9H3m/7yfdLCxcJjgXJ30=";
  };

  build-system = [ setuptools ];

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
