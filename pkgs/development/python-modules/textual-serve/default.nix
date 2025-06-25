{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  aiohttp-jinja2,
  jinja2,
  rich,
  textual,
}:

buildPythonPackage rec {
  pname = "textual-serve";
  version = "1.1.2";
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    pname = "textual_serve";
    inherit version;
    hash = "sha256-DMr5ud+cCNSy16CIfK0yciQ7qH9oGSw2T0vtW2g+S9Q=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    aiohttp
    aiohttp-jinja2
    jinja2
    rich
    textual
  ];

  pythonImportsCheck = [
    "textual_serve"
  ];

  # No tests in the pypi archive
  doCheck = false;

  meta = {
    description = "Turn your Textual TUIs in to web applications";
    homepage = "https://pypi.org/project/textual-serve/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
