{ stdenv, lib, fetchurl, fetchzip, jre, makeWrapper }:

let
translation-file = fetchurl {
  url = "https://gitlab.com/bmwinger/tr-patcher/-/raw/master/lib/Translation.txt?inline=false";
  sha256 = "136zd2s73b4n1w2n34wxi656bm448748nn3y7a64fd89ysg9n7n8";
};
in
stdenv.mkDerivation rec {
  pname = "tr-patcher";
  version = "1.0.5";

  # use the pre compiled source, as compilation is a bit complex
  src = fetchzip {
    url = "https://gitlab.com/bmwinger/tr-patcher/uploads/b57899980b2351c136393f02977c4fab/tr-patcher-shadow.zip";
    sha256 = "0va7nbmlgf3p2nc0z2b9n1285y4q5rpyjr4w93rdnx38wrhinxnw";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm644 lib/tr-patcher-all.jar $out/lib/tr-patcher.jar
    install -Dm644 ${translation-file} $out/lib/Translation.txt
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/tr-patcher \
    --add-flags "-jar $out/lib/tr-patcher.jar"
  '';

  meta = with lib; {
    description = "Allow to update dependancies of the Tamriel-Data mod for morrowind";
    homepage = "https://gitlab.com/bmwinger/tr-patcher";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = [ maintainers.marius851000 ];
    platforms = platforms.linux;
  };
}
