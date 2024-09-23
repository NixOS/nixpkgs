{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  dist-meta,
  dom-toml,
  domdf-python-tools,
  packaging,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "shippinglabel";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hZYsK+IX/a4bZMtD+hMEYDnwgqhdkkEHkG0MPkAgy20=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dist-meta
    dom-toml
    domdf-python-tools
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [ ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = {
    description = "Utilities for handling packages.";
    homepage = "https://github.com/domdfcoding/shippinglabel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
