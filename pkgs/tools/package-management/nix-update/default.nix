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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-q3kC+CJ0+NRz3rqHFuJkiI4RCSAXZczqDiyfQB2CrFQ=";
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
