{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "seyren-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/scobal/seyren/releases/download/${version}/seyren-${version}.jar";
    sha256 = "14p97yzfyacvavfms8qs3q5515vpfkjlfvislbwrf7qa89xzz8x0";
  };

  phases = ["installPhase"];

  buildInputs = [ makeWrapper jre src ];

  installPhase = ''
    mkdir -p "$out"/bin
    makeWrapper "${jre}/bin/java" "$out"/bin/seyren --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "An alerting dashboard for Graphite";
    homepage = https://github.com/scobal/seyren;
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.all;
  };
}
