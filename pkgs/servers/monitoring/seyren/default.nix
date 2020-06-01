{ stdenv, fetchurl, makeWrapper, jre8 }:

stdenv.mkDerivation rec {
  pname = "seyren";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/scobal/seyren/releases/download/${version}/seyren-${version}.jar";
    sha256 = "1fixij04n8hgmaj8kw8i6vclwyd6n94x0n6ify73ynm6dfv8g37x";
  };

  phases = ["installPhase"];

  buildInputs = [ makeWrapper jre8 ];

  installPhase = ''
    mkdir -p "$out"/bin
    makeWrapper "${jre8}/bin/java" "$out"/bin/seyren --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "An alerting dashboard for Graphite";
    homepage = "https://github.com/scobal/seyren";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.all;
  };
}
