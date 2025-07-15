{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-logger-plugins";
  version = "1.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-logger-plugins";
    tag = "v${version}";
    hash = "sha256-VHbta+R2a/K2L03IRu/Ya7dJzshIAvyK9cNIRbx8QqM=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_logger_plugins" ];

  meta = with lib; {
    description = "A stable interface for interactions between Snakemake and its logger plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-logger-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
