{ lib
, buildPythonApplication
, fetchFromGitHub
, nix
, nixpkgs-fmt
, nixpkgs-review
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-wivScgtcdapf5bfXR1sjuBIPQEgi6QGH/f+Aucc3CEQ=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nixpkgs-fmt nixpkgs-review ])
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
