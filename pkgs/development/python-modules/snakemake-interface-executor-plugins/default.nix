{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  argparse-dataclass,
  throttler,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-executor-plugins";
  version = "9.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-executor-plugins";
    tag = "v${version}";
    hash = "sha256-NiOVUHB9UU1ZqNAVomZmpzyzDwtbLCd+2MaIvpo5G7k=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    argparse-dataclass
    throttler
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_executor_plugins" ];

  meta = {
    description = "This package provides a stable interface for interactions between Snakemake and its executor plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-executor-plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-executor-plugins/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
