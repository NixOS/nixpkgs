{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  audioop-lts,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "standard-sunau";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/sunau";

  build-system = [
    setuptools
  ];

  dependencies = [
    audioop-lts
  ];

  pythonImportsCheck = [ "sunau" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Standard library sunau redistribution";
    homepage = "https://github.com/youknowone/python-deadlib/tree/main/sunau";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
