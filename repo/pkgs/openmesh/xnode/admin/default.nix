{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "b3ea84ac6d095dfaf260976dd04a84d2cd77c21c";
    sha256 = "1q14lvppzyimmrpnmznxycv0x0k0d86h9v2mm7wyg9wqw45c1ypw";
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
