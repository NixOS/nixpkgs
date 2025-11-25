{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-images";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "images";
    tag = version;
    hash = "sha256-olkczYxvdUgLZXmvA0SUXL2q+NL4tvUfRWBG7S05dQU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    sphinx
  ];

  pythonImportsCheck = [
    "sphinxcontrib.images"
  ];

  meta = {
    description = "Sphinx extension for thumbnails";
    homepage = "https://pypi.org/project/sphinxcontrib-images/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
