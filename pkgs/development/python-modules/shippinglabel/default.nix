{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  dist-meta,
  dom-toml,
  domdf-python-tools,
  hatchling,
  hatch-requirements-txt,
  packaging,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "shippinglabel";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uvQ6MjHp1X63PlEDQKaiYMLoB7/gqs4KfFyZoCeNNXQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dist-meta
    dom-toml
    domdf-python-tools
    packaging
    typing-extensions
    hatchling
    hatch-requirements-txt
  ];

  meta = {
    description = "Utilities for handling packages.";
    homepage = "https://github.com/domdfcoding/shippinglabel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
