{ lib
, buildPythonApplication
, fetchFromGitHub
, nix
, nix-prefetch
, nixpkgs-fmt
, nixpkgs-review
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-d2S18cBkFJOIGFKrwj9U4bRvdPjrbuWfRUVug1JEw0s=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch nixpkgs-fmt nixpkgs-review ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help >/dev/null
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 zowoq ];
    platforms = platforms.all;
  };
}
