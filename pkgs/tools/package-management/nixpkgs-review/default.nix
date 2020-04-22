{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "0qkvjl4f8a1905yj3ml32rfdr5q76igz21gn3dcya0pfqhrnb28i";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix git ])
  ];

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
