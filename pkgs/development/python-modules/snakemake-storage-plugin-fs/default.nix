{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  snakemake-interface-common,
  snakemake-interface-storage-plugins,
  sysrsync,

  # tests
  pytestCheckHook,
  snakemake,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-storage-plugin-fs";
  version = "1.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-fs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UdK0yhl7ljLh57CXAvH/OYiVyw+BjhPwGjSBXX8sbZk=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    snakemake-interface-common
    snakemake-interface-storage-plugins
    sysrsync
  ];

  pythonImportsCheck = [ "snakemake_storage_plugin_fs" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Snakemake storage plugin that reads and writes from a locally mounted filesystem using rsync";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-fs";
    changelog = "https://github.com/snakemake/snakemake-storage-plugin-fs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
