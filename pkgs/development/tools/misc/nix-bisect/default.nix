{
  lib,
  fetchpatch,
  fetchFromGitHub,
  python3,
}:

let
  pname = "nix-bisect";
  version = "0.4.1-unstable-2024-04-19";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "timokau";
    repo = pname;
    rev = "4f26082fec0817acbfa8cc6ca4c25caaf77ddcd2";
    hash = "sha256-zyeE1jYo/9NEG8fB4gQBAR01siP4tyLvjjHN1yUS4Ug=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    numpy
    pexpect
  ];

  doCheck = false;

  meta = with lib; {
    description = "Bisect nix builds";
    homepage = "https://github.com/timokau/nix-bisect";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
