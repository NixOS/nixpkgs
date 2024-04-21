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
  version = "1.17.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-N8mSS+gABAgXm01BcsMk89a3HsIsc3RHxCAi3GlxtRg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    argparse-dataclass
    configargparse
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "snakemake_interface_common" ];

  pytestFlagsArray = [ "tests/tests.py" ];

  meta = with lib; {
    description = "Common functions and classes for Snakemake and its plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-common";
    changelog = "https://github.com/snakemake/snakemake-interface-common/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
