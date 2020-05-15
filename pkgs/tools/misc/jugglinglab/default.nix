{ stdenv, fetchgit, jre, makeWrapper, ant, jdk }:
stdenv.mkDerivation rec {
  major= "1";
  minor = "2";
  version = "${major}.${minor}";
  name = "jugglinglab";
  src = fetchgit {
    url = "https://github.com/jkboyce/jugglinglab";
    rev = "v${major}.${minor}";
    sha256 = "1p62kb9hfch7pi4way18c5mgky4xbxcrfgrw0hd25sd6cpr88z92";
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

  meta = with stdenv.lib; {
      description = "A program to visualize different juggling pattens";
      license = licenses.gpl2;
      maintainers = with maintainers; [ wnklmnn ];
  };
}