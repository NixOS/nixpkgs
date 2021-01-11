{ lib, stdenv, fetchFromGitHub, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    sha256 = "10y42nn9lgkwdjia74qfyf937nam4md3pkyfjinj7jybvcran4bj";
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
