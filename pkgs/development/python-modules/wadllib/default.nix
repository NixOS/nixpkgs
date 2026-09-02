{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lazr-uri,
}:

buildPythonPackage (finalAttrs: {
  pname = "wadllib";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-acYKGIycYpoOlH36/Yms3It9jUBKa16wrSWP7yk2JQE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lazr-uri
  ];

  pythonImportsCheck = [ "wadllib" ];

  # pypi tarball has no tests
  doCheck = false;

  meta = {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
})
