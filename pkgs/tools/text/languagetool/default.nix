{ lib, stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "5.2";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "1fz3rxqg5z2jxbalraz8lwkzj0jh69zzfmf3vpwywilvl7xlhdrd";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share
    mv -- * $out/share/

    for lt in languagetool{,-commandline,-server};do
      makeWrapper ${jre}/bin/java $out/bin/$lt \
        --add-flags "-cp $out/share/ -jar $out/share/$lt.jar"
    done

    makeWrapper ${jre}/bin/java $out/bin/languagetool-http-server \
      --add-flags "-cp $out/share/languagetool-server.jar org.languagetool.server.HTTPServer"
  '';

  meta = with lib; {
    homepage = "https://languagetool.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ edwtjo ];
    platforms = jre.meta.platforms;
    description = "A proofreading program for English, French German, Polish, and more";
  };
}
