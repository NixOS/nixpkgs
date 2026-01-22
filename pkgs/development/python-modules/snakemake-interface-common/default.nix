{
  lib,
  argparse-dataclass,
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-common";
    tag = "v${version}";
    hash = "sha256-DxbB/UaBkLbG18CGHyDMo7dmRlVY2tD3BhO0MShbnq4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argparse-dataclass
    configargparse
  ];

  pythonImportsCheck = [ "snakemake_interface_common" ];

  # test_snakemake_version: No module named 'snakemake'
  # nativeCheckInputs = [ pytestCheckHook ];

  # enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Common functions and classes for Snakemake and its plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-common";
    changelog = "https://github.com/snakemake/snakemake-interface-common/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
