{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.1";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "b8fc58a076f5b07cb873dee8167134f8d6bded83";
    sha256 = "0bcbx5zfivncbi8ajclg55s1f6af84aq82w23bn8ynbmd6dvp9k6";
  };

  nativeBuildInputs = [
    pkgs.python3Packages.hatchling
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    gitpython
    psutil
    requests
  ];

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Agent service for Xnode reconfiguration and management";
    mainProgram = "openmesh-xnode-admin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ harrys522 j-openmesh ];
  };
}
