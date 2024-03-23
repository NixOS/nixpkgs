{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, snakemake-interface-executor-plugins
, snakemake-interface-common
}:

buildPythonPackage rec {
  pname = "snakemake-executor-plugin-cluster-generic";
  version = "1.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+aGd+E+VQb7MflsiUgFR98AyeetZxbc4gdvU1JWJNcM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    snakemake-interface-executor-plugins
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_executor_plugin_cluster_generic" ];

  meta = with lib; {
    description = "Generic cluster executor for Snakemake";
    homepage = "https://github.com/snakemake/snakemake-executor-plugin-cluster-generic/tags";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
