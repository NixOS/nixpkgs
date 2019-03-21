{ stdenv, fetchFromGitHub, which, curl, makeWrapper, jdk }:

let
  rev = "a9f2e2592d069313329971930d1740943d19ef91";
  version = "2019-01-30";
in
stdenv.mkDerivation {
  name = "sbt-extras-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "1kkpsd3fb8lm631bwjj41x4i9a5m88y2f3flzs918y12bjkli8ji";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    substituteInPlace bin/sbt --replace 'declare java_cmd="java"' 'declare java_cmd="${jdk}/bin/java"'

    install bin/sbt $out/bin

    wrapProgram $out/bin/sbt --prefix PATH : ${stdenv.lib.makeBinPath [ which curl ]}
  '';

  meta = {
    description = "A more featureful runner for sbt, the simple/scala/standard build tool";
    homepage = https://github.com/paulp/sbt-extras;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
