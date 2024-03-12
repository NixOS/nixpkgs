{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, argparse-dataclass
, configargparse
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.17.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-23PGKSBX7KMt0Q7sWiLIPfCkxr2HtBas7flYeNHABWM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    argparse-dataclass
    configargparse
  ];

  pythonImportsCheck = [ "snakemake_interface_common" ];

  meta = with lib; {
    description = "Common functions and classes for Snakemake and its plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-common";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
