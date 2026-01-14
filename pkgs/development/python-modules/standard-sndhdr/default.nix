{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  standard-aifc,
}:

buildPythonPackage rec {
  pname = "standard-sndhdr";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/sndhdr";

  build-system = [ setuptools ];

  dependencies = [
    standard-aifc
  ];

  pythonImportsCheck = [ "sndhdr" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Standard library sndhdr redistribution";
    homepage = "https://github.com/youknowone/python-deadlib/tree/main/sndhdr";
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
