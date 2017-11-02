{ stdenv, lib, fetchurl, unzip, jdk }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "3.7";
  name = pname + "-" + version;
  src = fetchurl {
    url = "https://www.languagetool.org/download/${name}.zip";
    sha256 = "04i49z022k3nyyr8hnlxima9k5id8qvh2nr3dv8zgcqm5sin6xx9";
  };
  buildInputs = [ unzip jdk ];
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    mv * $out/share/.
    for lt in languagetool{,-commandline,-server};do
    cat > $out/bin/$lt <<EXE
    #!${stdenv.shell}
    ${jdk}/bin/java -cp $out/share/ -jar $out/share/$lt.jar "\$@"
    EXE
    chmod +x $out/bin/$lt
    done
    cat > $out/bin/languagetool-http-server <<EXE
    #!${stdenv.shell}
    ${jdk}/bin/java -cp $out/share/languagetool-server.jar org.languagetool.server.HTTPServer "\$@"
    EXE
    chmod +x $out/bin/languagetool-http-server
  '';

  meta = with stdenv.lib; {
    homepage = https://languagetool.org;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      edwtjo
      jgeerds
    ];
    descrption = "A proofreading program for English, French German, Polish, and more";
  };
}
