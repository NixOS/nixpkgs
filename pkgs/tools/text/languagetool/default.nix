{ stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "4.8";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "0xhzrrw52mqsv3n1rr98p8zi84i63gpcd104ahkkhhyzwvy9kprc";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share
    mv * $out/share/

    for lt in languagetool{,-commandline,-server};do
      makeWrapper ${jre}/bin/java $out/bin/$lt \
        --add-flags "-cp $out/share/ -jar $out/share/$lt.jar"
    done

    makeWrapper ${jre}/bin/java $out/bin/languagetool-http-server \
      --add-flags "-cp $out/share/languagetool-server.jar org.languagetool.server.HTTPServer"
  '';

  meta = with stdenv.lib; {
    homepage = https://languagetool.org;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      edwtjo
    ];
    description = "A proofreading program for English, French German, Polish, and more";
  };
}
