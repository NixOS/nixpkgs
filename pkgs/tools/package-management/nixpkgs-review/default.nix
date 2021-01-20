{ stdenv
, python3
, fetchFromGitHub
, nixFlakes
, git
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "1k4i54j5if86qf9dmwm8ybfc4j7ap40y82f03hxfxb7lzq5cqmcv";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nixFlakes git ])
  ];

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
