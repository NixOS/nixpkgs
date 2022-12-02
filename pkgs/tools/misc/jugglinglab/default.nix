{ lib, stdenv, fetchFromGitHub, jre, makeWrapper, ant, jdk }:
stdenv.mkDerivation rec {
  version = "1.6.3";
  pname = "jugglinglab";
  src = fetchFromGitHub {
    owner = "jkboyce";
    repo = "jugglinglab";
    rev = "v${version}";
    sha256 = "sha256-Gq8V7gLl9IakQi7xaK8TCI/B2+6LlLjoLdcv9zlalIE=";
  };
  buildInputs = [ jre ];
  nativeBuildInputs = [ ant jdk makeWrapper ];
  buildPhase = "ant";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    cp bin/*.jar $out/lib/

    # copied from the upstream shell wrapper
    classpath=$out/lib/JugglingLab.jar:$out/lib/commons-math3-3.6.1.jar:$out/lib/protobuf.jar:$out/lib/com.google.ortools.jar

    makeWrapper ${jre}/bin/java $out/bin/jugglinglab \
      --add-flags "-cp $classpath" \
      --add-flags "-Xss2048k -Djava.library.path=ortools-lib" \
      --add-flags jugglinglab.JugglingLab
  '';

  meta = with lib; {
      description = "A program to visualize different juggling pattens";
      homepage = "https://jugglinglab.org/";
      license = licenses.gpl2;
      maintainers = with maintainers; [ wnklmnn ];
      platforms = platforms.all;
  };
}
