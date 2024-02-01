{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, argparse-dataclass
, configargparse
}:

buildPythonPackage rec {
  pname = "snakemake-interface-common";
  version = "1.15.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-f4C/g2h6W72q1XQMDm/RvnRcOSPWyEMuZXqkVEY7S70=";
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
