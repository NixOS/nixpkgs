{ lib
, buildPythonApplication
, fetchFromGitHub
, nixFlakes
, nix-prefetch
, nixpkgs-fmt
, nixpkgs-review
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-n3YuNypKFaBtO5Fhf7Z3Wgh0+WH5bQWR0W0uHCYKtuY=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nixFlakes nix-prefetch nixpkgs-fmt nixpkgs-review ])
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
