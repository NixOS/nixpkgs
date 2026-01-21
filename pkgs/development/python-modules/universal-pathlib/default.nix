{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fsspec,
}:

buildPythonPackage rec {
  pname = "universal-pathlib";
  version = "0.3.8";
  pyproject = true;

  src = fetchPypi {
    pname = "universal_pathlib";
    inherit version;
    hash = "sha256-6tK2W8o99uEcO3yzb8mEY0C8PC2071cTFVAmBCKwo+g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ fsspec ];

  pythonImportsCheck = [ "upath" ];

  meta = {
    description = "Pathlib api extended to use fsspec backends";
    homepage = "https://github.com/fsspec/universal_pathlib";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
