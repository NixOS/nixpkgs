{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, argparse-dataclass
, configargparse
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.16.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rqeDRbB77ttPYoQQtvv44IjXmotlrUA1Dssf1nLKnKs=";
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
