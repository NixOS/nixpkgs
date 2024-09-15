{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  
  pytestCheckHook,

  # Package dependencies 
  jaraco-context,
  more-itertools,
  xmltodict,
  httpx,
  multidict,
}:

buildPythonPackage rec {
  pname = "wolframalpha";
  version = "5.1.3";

  src = fetchPypi {
    inherit pname version;
    hash = "";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jaraco-context
    more-itertools
    xmltodict
    httpx
    multidict
  ];
  
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jaraco/wolframalpha/releases/tag/v${version}";
    homepage = "https://github.com/jaraco/wolframalpha";
    description = "Python Client built against the Wolfram|Alpha v2.0 API.";
    license = lib.licenses.mit;
  }

}
