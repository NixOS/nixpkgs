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
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XwE/b7TQ7i+2hMSdZJhyVjl2lieweZLbA6PXcSJTnFE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dist-meta
    dom-toml
    domdf-python-tools
    packaging
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = with lib; {
    description = "Utilities for handling packages.";
    homepage = "https://github.com/domdfcoding/shippinglabel";
    license = licenses.mit;
    maintainers = with maintainers; [ tyberius-prime ];
  };
}
