{ lib
, python3
, fetchFromGitHub
, nixFlakes
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "sha256-096oSvc9DidURGKE0FNEBOQz82+RGg6aJo8o9HhaSp0=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nixFlakes git ])
  ];

  doCheck = false;

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
