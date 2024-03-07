{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, argparse-dataclass
, throttler
, snakemake-interface-common
}:

buildPythonPackage rec {
  pname = "snakemake-interface-executor-plugins";
  version = "8.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZkhayXWy83/INRH7FYwFkhgHL+nSj7ReYC9I97SEeTM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    argparse-dataclass
    throttler
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_executor_plugins" ];

  meta = with lib; {
    description = "This package provides a stable interface for interactions between Snakemake and its executor plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-executor-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
