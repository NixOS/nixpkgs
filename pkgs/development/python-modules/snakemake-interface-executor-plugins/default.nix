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
  version = "9.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DW8fxBBP6U7N0Hgk/enOzUz68L7pCjVl/8MFCy6PKxg=";
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
