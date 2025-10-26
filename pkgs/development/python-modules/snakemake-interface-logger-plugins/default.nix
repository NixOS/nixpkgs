{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-logger-plugins";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-logger-plugins";
    tag = "v${version}";
    hash = "sha256-GPf8FdoBHpyQADWvJ7jOF4PpLk6/Ui+nXIE/rUSIAg8=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_logger_plugins" ];

  meta = with lib; {
    description = "Stable interface for interactions between Snakemake and its logger plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-logger-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
