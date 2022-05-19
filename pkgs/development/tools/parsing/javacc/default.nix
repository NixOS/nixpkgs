{ stdenv, lib, fetchFromGitHub, ant, jdk }:

stdenv.mkDerivation rec {
  pname = "javacc";
  version = "7.0.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "120jva4sw1kylkwgqf869zxddss01mcn1nmimx9vmd4xaadz7cf2";
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
