{ lib, stdenv, fetchFromGitHub, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-RyQZ9F+rZ0a/90hljSyNCzYK8eA3rYJlJkV7B5NPRzY=";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp h $out/bin/h
    cp up $out/bin/up
  '';

  meta = with lib; {
    description = "faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
