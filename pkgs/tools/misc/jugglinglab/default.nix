{ lib, stdenv, fetchFromGitHub, jre, makeWrapper, ant, jdk }:
stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "jugglinglab";
  src = fetchFromGitHub {
    owner = "jkboyce";
    repo = "jugglinglab";
    rev = "1908012682d8c39a9b92248a20f285455104c510"; # v1.2.1 does not have a tag on Github
    sha256 = "0dvcyjwynvapqbjchrln59vdskrm3w6kh0knxcn4bx61vcz3171z";
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
