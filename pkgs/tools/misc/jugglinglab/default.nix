{ lib, stdenv, fetchFromGitHub, jre, makeWrapper, ant, jdk }:
stdenv.mkDerivation rec {
  version = "1.4.1";
  pname = "jugglinglab";
  src = fetchFromGitHub {
    owner = "jkboyce";
    repo = "jugglinglab";
    rev = "v${version}";
    sha256 = "sha256-GQm/TMQ1WSEn/6xOSqO0X3D8e/KpkQVz9Imtn6NDbOI=";
  };
  buildInputs = [ jre ];
  nativeBuildInputs = [ ant jdk makeWrapper ];
  buildPhase = "ant";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    cp bin/JugglingLab.jar $out/lib/

    makeWrapper ${jre}/bin/java $out/bin/jugglinglab \
      --add-flags "-jar $out/lib/JugglingLab.jar"
  '';

  meta = with lib; {
      description = "A program to visualize different juggling pattens";
      license = licenses.gpl2;
      maintainers = with maintainers; [ wnklmnn ];
      platforms = platforms.all;
  };
}
