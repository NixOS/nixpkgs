{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fsspec,
  pathlib-abc,
}:

buildPythonPackage (finalAttrs: {
  pname = "universal-pathlib";
  version = "0.3.10";
  pyproject = true;

  src = fetchPypi {
    pname = "universal_pathlib";
    inherit (finalAttrs) version;
    hash = "sha256-RIfLyQcwpIz7ZPgR2Z4UtvrtbXOEIM1fk/WfSOaTC/s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fsspec
    pathlib-abc
  ];

  pythonImportsCheck = [ "upath" ];

  meta = {
    description = "Pathlib api extended to use fsspec backends";
    homepage = "https://github.com/fsspec/universal_pathlib";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
