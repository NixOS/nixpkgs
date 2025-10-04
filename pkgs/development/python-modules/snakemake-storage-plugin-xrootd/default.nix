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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-xrootd";
    tag = "v${version}";
    hash = "sha256-vfMAgOTmT3uzUZHXeKsd8Ze3+b3nFsVHDhkPG+xvz+k=";
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

  meta = with lib; {
    description = "Snakemake storage plugin for handling input and output via XRootD";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-xrootd";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
