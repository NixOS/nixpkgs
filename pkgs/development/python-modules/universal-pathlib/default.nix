{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fsspec,
}:

buildPythonPackage rec {
  pname = "universal-pathlib";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "universal_pathlib";
    inherit version;
    hash = "sha256-6l1PuBeMKrRpz0+kbQzrFsyzeNpG27woqLnB7r3MxlU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ fsspec ];

  pythonImportsCheck = [ "upath" ];

  meta = with lib; {
    description = "Pathlib api extended to use fsspec backends";
    homepage = "https://github.com/fsspec/universal_pathlib";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
