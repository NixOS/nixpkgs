{
  buildPythonPackage,
  fetchPypi,
  lib,
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
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JcDDGUwBHANV3/j1bMCzFoj2k7IJ9YSdRJkdii7JHy8=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    dist-meta
    dom-toml
    domdf-python-tools
    packaging
    typing-extensions
  ];

  meta = {
    description = "Utilities for handling packages";
    homepage = "https://github.com/domdfcoding/shippinglabel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
