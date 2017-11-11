{ stdenv, fetchFromGitHub, which, curl, makeWrapper }:

let
  rev = "77686b3dfa20a34270cc52377c8e37c3a461e484";
  version = stdenv.lib.strings.substring 0 7 rev;
in
stdenv.mkDerivation {
  name = "sbt-extras-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "1bhqigm0clv3i1gvn4gsllywcnwfsa73xvqp8m7pbvn8g7i2ws6x";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install bin/sbt $out/bin

    wrapProgram $out/bin/sbt --prefix PATH : ${stdenv.lib.makeBinPath [ which curl]}
  '';

  meta = {
    description = "A more featureful runner for sbt, the simple/scala/standard build tool";
    homepage = https://github.com/paulp/sbt-extras;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
