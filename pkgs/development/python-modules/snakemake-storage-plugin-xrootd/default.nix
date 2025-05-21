{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake,
  snakemake-interface-storage-plugins,
  snakemake-interface-common,
  xrootd,
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-xrootd";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Wo6eF8XlHh9OiD2rTMCchyq1sQ8gjkKnoD4JsKDmJ2A=";
  };

  # xrootd<6.0.0,>=5.6.4 not satisfied by version 5.7rc20240303
  pythonRelaxDeps = [ "xrootd" ];

  build-system = [ poetry-core ];

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
