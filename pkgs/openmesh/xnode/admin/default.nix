{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "8a03f2774025fc97339880d64ea0fa62223b7dd9";
    sha256 = "0bhd4yng12whha34pvf73gbzhgx0br85278n7n7wack5hqqmqnpy";
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
