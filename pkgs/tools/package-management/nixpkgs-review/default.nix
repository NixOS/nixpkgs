{ lib
, python3
, fetchFromGitHub
, nix
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "sha256-6vKMaCTilPXd8K3AuLqtYInVyyFhdun0o9cX1WRMmWo=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ nix git ]}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 SuperSandro2000 ];
  };
}
