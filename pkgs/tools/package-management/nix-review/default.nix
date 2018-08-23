{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "0ncifmp90870v6r651p92wbvpayfblm5k9nxikryjaj1fnvd2np3";
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
