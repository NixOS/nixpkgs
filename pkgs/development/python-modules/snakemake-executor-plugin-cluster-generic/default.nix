{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake-interface-executor-plugins,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-executor-plugin-cluster-generic";
  version = "1.0.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-executor-plugin-cluster-generic";
    tag = "v${version}";
    hash = "sha256-RHMefoJOZb6TjRsFCORLFdHtI5ZpTsV6CHrjHKMat9o=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    snakemake-interface-executor-plugins
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_executor_plugin_cluster_generic" ];

  meta = with lib; {
    description = "Generic cluster executor for Snakemake";
    homepage = "https://github.com/snakemake/snakemake-executor-plugin-cluster-generic";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
