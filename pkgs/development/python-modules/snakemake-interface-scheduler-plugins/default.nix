{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  snakemake-interface-common,
}:

let
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-scheduler-plugins";
    tag = "v${version}";
    hash = "sha256-Z/rJGkby9AcYB+Gil00xhbrySChqEIEOtzLyzQPhObk=";
  };
in
buildPythonPackage {
  pname = "snakemake-interface-scheduler-plugins";
  inherit version src;
  pyproject = true;

  build-system = [ hatchling ];

  dependencies = [ snakemake-interface-common ];

  pythonImportsCheck = [ "snakemake_interface_scheduler_plugins" ];

  # test_scheduler: No module named 'snakemake'
  # nativeCheckInputs = [ pytestCheckHook ];

  # enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Provides a stable interface for interactions between Snakemake and its scheduler plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-scheduler-plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-scheduler-plugins/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
