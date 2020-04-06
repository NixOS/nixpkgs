{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "0qsvrcxl97nih1yprydzlqc6n1ppg726664d6harx5kjzp5776mr";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix git ])
  ];

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = https://github.com/Mic92/nixpkgs-review;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
