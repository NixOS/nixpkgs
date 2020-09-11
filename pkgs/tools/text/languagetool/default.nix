{ stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "5.0";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "1jyd4z62ldwhqx9r7v4b9k4pl300wr4b7ggj4f0yjf0gpwg7l9p7";
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
    homepage = "https://languagetool.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      edwtjo
    ];
    description = "A proofreading program for English, French German, Polish, and more";
  };
}
