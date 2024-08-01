{ pkgs, lib, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "xnode-admin";
  version = "0.0.3";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = pname;
    rev = "665debd5246b995314082330cfe16afb59d3579a";
    sha256 = "1qmjswhs95894i6fnw5qj336w3254lhivgdqvg0anwhr3g5p7zqb";
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
