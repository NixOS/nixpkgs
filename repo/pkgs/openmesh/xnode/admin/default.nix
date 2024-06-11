{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "48f7724fe62308465572dc1d53842776b4a2dcdd";
    sha256 = "19vmk9fxm3q0x6as2rrcr1dcrf68v1xwf1dbrphh98ivnqb4yfym";
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
