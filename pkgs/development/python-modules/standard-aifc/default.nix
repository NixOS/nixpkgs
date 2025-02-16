{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  audioop-lts,
  standard-chunk,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "standard-aifc";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/aifc";

  build-system = [
    setuptools
  ];

  dependencies = [
    audioop-lts
    standard-chunk
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "aifc"
  ];

  meta = {
    description = "Standard library aifc redistribution";
    homepage = "https://github.com/youknowone/python-deadlib/tree/main/aifc";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
