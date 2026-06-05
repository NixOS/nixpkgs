{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  requests,
  requests-oauthlib,
  snakemake-interface-common,
  snakemake-interface-storage-plugins,

  # tests
  pytestCheckHook,
  snakemake,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-storage-plugin-http";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-http";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ad4IOjU761CaZ+o0//I8/xW+e+4UJG0+VAbQ9KcNjFY=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "requests-oauthlib"
  ];
  dependencies = [
    requests
    requests-oauthlib
    snakemake-interface-common
    snakemake-interface-storage-plugins
  ];

  pythonImportsCheck = [ "snakemake_storage_plugin_http" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  disabledTests = [
    # Requires internet access
    "test_storage"
  ];

  meta = {
    description = "Snakemake storage plugin for donwloading input files from HTTP(s)";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-http";
    changelog = "https://github.com/snakemake/snakemake-storage-plugin-http/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
