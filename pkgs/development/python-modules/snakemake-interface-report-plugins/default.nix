{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, snakemake-interface-common
}:

buildPythonPackage rec {
  pname = "snakemake-interface-report-plugins";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-30x4avA3FrqZ4GoTl6Js5h3VG5LW7BNHOcNWxznXoT0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_report_plugins" ];

  meta = with lib; {
    description = "The interface for Snakemake report plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-report-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
