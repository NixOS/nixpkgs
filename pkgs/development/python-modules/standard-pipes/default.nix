{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "standard-pipes";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/pipes";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pipes" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Standard library pipes redistribution";
    homepage = "https://github.com/youknowone/python-deadlib/tree/main/pipes";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
