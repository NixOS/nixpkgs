{ lib
, python3
, fetchFromGitHub
, nixUnstable
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "sha256-wDGmkydBLb3Wij1hjWExgHxva/03vJFqAK5zGH9yUn4=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nixUnstable git ])
  ];

  doCheck = false;

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
