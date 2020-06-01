{ stdenv, fetchzip, jre8, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "4.9.1";

  src = fetchzip {
    url = "https://www.languagetool.org/download/${pname}-${version}.zip";
    sha256 = "0hvzckb92yijzmp2vphjp1wgql3xqq0xd83v5x6pbhziq9yxc5yh";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre8 ];

  installPhase = ''
    mkdir -p $out/share
    mv * $out/share/

    for lt in languagetool{,-commandline,-server};do
      makeWrapper ${jre8}/bin/java $out/bin/$lt \
        --add-flags "-cp $out/share/ -jar $out/share/$lt.jar"
    done

    makeWrapper ${jre8}/bin/java $out/bin/languagetool-http-server \
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
