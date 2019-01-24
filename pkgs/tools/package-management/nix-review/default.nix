{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "13dv2zpnhf218hfmixsgsbvy9zgrp7b0d125hvq8sk5x57f6114q";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ nix git ]}"
  ];

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = https://github.com/Mic92/nix-review;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
