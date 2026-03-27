{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  snakemake,
  snakemake-interface-storage-plugins,
  snakemake-interface-common,
  xrootd,
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-xrootd";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-xrootd";
    tag = "v${version}";
    hash = "sha256-QYG/BE7y3h/Mz1PrVVxmfBBLBLoirrEx9unSEaflUds=";
  };

  # xrootd<6.0.0,>=5.6.4 not satisfied by version 5.7rc20240303
  pythonRelaxDeps = [ "xrootd" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    snakemake-interface-storage-plugins
    snakemake-interface-common
    xrootd
  ];

  nativeCheckInputs = [ snakemake ];

  pythonImportsCheck = [ "snakemake_storage_plugin_xrootd" ];

  meta = {
    description = "Snakemake storage plugin for handling input and output via XRootD";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-xrootd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
