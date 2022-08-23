{ stdenv, lib, fetchFromGitHub, ant, jdk }:

stdenv.mkDerivation rec {
  pname = "javacc";
  version = "7.0.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-tDtstF3ivKjG01vOZ8Ga1zTjIZFSTWt5QPY1VQvyFMU=";
  };

  nativeBuildInputs = [ ant jdk ];

  buildPhase = ''
    ant jar
  '';

  installPhase = ''
    mkdir -p $out/target
    mv scripts $out/bin
    mv target/javacc.jar $out/target/
  '';

  meta = with lib; {
    homepage = "https://javacc.github.io/javacc";
    description = "A parser generator for building parsers from grammars";
    license = licenses.bsd2;
    maintainers = teams.deshaw.members;
  };
}
