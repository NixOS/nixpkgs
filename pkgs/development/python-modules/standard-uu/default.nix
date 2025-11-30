{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "standard-uu";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/uu";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "uu" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Standard library sndhdr redistribution";
    homepage = "https://github.com/youknowone/python-deadlib/tree/main/uu";
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
