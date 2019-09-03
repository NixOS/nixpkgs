{ stdenv, fetchFromGitHub, which, curl, makeWrapper, jdk }:

let
  rev = "53f1edc685d8f269ac551336809e34faf7cd29a6";
  version = "2019-08-14";
in
stdenv.mkDerivation {
  name = "sbt-extras-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "1fyfwcnr30c0rgq6xfd2is9a8j1hsrl2p0xqicwqi4bzijy4r6gw";
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
