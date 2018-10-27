{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "14ak0qfc5faamnp4fmrqmb1ikpv656nr830rja89yzc96s73337z";
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
