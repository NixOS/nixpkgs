{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "0ggw90zp40mms4hpphcn1vy1764rbvl2ix45h26v0wkn32cbqn49";
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
