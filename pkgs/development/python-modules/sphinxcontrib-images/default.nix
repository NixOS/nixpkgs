{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-images";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9sI30EMHk+ZdkdvdsTsfsmos+DgECp3utSESlp+8Sks=";
  };

  build-system = [
    setuptools
    wheel
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
