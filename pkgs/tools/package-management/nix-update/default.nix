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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-CkdiNXWhMYjqdxHSSB5qjEiD6cZF6NQfjCUMrLxz8/Q=";
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
