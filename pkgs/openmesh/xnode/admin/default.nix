{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "051f20b96044a447af3a3681c4d2a5d145aa948d";
    sha256 = "07nax080w0ww5x6sbmn3qlg78n4zx7358sd8476sw5pgfnw7sjmx";
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
