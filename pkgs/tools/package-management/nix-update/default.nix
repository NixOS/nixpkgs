{ lib
, buildPythonApplication
, fetchFromGitHub
, nix
, nix-prefetch
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "0mw31n7kqfr7fskkxp58b0wprxj1pj6n1zs6ymvvl548gs5rgn2s";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 zowoq ];
    platforms = platforms.all;
  };
}
