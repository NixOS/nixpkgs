{
  lib,
  argparse-dataclass,
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.21.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-common";
    tag = "v${version}";
    hash = "sha256-8QISVZZ/kwWBNFtndzysnxFuuemkDXcWqEtCdVVsANo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    argparse-dataclass
    configargparse
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "snakemake_interface_common" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = with lib; {
    description = "Common functions and classes for Snakemake and its plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-common";
    changelog = "https://github.com/snakemake/snakemake-interface-common/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
