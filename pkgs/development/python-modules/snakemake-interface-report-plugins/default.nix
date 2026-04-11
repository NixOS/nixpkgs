{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-report-plugins";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-report-plugins";
    tag = "v${version}";
    hash = "sha256-3ugEmdO1dcusKXXBZBRszlZXX5fhJyYSSF5Uj5CKJkQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ snakemake-interface-common ];

  pythonImportsCheck = [ "snakemake_interface_report_plugins" ];

  meta = {
    description = "Interface for Snakemake report plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-report-plugins";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
