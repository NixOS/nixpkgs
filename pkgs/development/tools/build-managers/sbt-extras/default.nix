{ stdenv, fetchFromGitHub, which, curl, makeWrapper, jdk }:

let
  rev = "3c8fcadc3376edfd8e4b08b35f174935bf97bbac";
  version = stdenv.lib.strings.substring 0 7 rev;
in
stdenv.mkDerivation {
  name = "sbt-extras-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "0r79w4kgdrsdnm4ma9rmb9k115rvidpaha7sr9rsxv68jpagwgrj";
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
