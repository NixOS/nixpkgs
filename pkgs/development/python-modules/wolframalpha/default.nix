{
  lib,
  buildPythonPackage,
  fetchPypi,

  # Build system
  setuptools,
  setuptools-scm,

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
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ViJu/soPVazsXhfdL2U3oXjQv0/uxN8GFRZeKWi7Sbg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaraco-context
    more-itertools
    xmltodict
    httpx
    multidict
  ];

  doCheck = false;
  pythonImportsCheck = [ "wolframalpha" ];
  meta = {
    changelog = "https://github.com/jaraco/wolframalpha/releases/tag/v${version}";
    homepage = "https://github.com/jaraco/wolframalpha";
    description = "Python Client for the Wolfram|Alpha v2.0 API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ duckle29 ];
  };

}
