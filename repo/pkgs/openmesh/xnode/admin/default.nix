{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "568ca78e3881f1b2af988b6846ab59f316f2e731";
    sha256 = "e/GVoWFKEp54gZNkllAf7Q9rBogJ0bSa3aT62pelutw=";
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
      #license = with licenses; [ x ];
      maintainers = with maintainers; [ harrys522 j-openmesh ];
    };
}
