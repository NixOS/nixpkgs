{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  reretry,
  snakemake-interface-common,
  snakemake-interface-storage-plugins,
  xrootd,

  # tests
  pytestCheckHook,
  snakemake,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-storage-plugin-xrootd";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-xrootd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vL9JD9h0ywsKpUPoXhgg6b+vwi7kxK8CF3L6HnAEidE=";
  };

  postPatch = ''
    substituteInPlace tests/tests.py \
      --replace-fail \
        'subprocess.Popen(["xrootd",' \
        'subprocess.Popen(["${lib.getExe pkgs.xrootd}",'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    snakemake-interface-storage-plugins
    snakemake-interface-common
    reretry
    xrootd
  ];

  pythonImportsCheck = [ "snakemake_storage_plugin_xrootd" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Snakemake storage plugin for handling input and output via XRootD";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-xrootd";
    changelog = "https://github.com/snakemake/snakemake-storage-plugin-xrootd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
