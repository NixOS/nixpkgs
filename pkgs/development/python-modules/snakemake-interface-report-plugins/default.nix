{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-report-plugins";
  version = "1.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-report-plugins";
    tag = "v${version}";
    hash = "sha256-PSybPYo7soq7GHY7mo9q0yGxoFX2pvVeAXgRsa6oXoo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ snakemake-interface-common ];

  pythonImportsCheck = [ "snakemake_interface_report_plugins" ];

  meta = with lib; {
    description = "Interface for Snakemake report plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-report-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
