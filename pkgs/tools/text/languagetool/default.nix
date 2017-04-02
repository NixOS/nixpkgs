{ stdenv, lib, fetchurl, unzip, jdk }:

stdenv.mkDerivation rec {
  pname = "LanguageTool";
  version = "3.5";
  name = pname + "-" + version;
  src = fetchurl {
    url = "https://www.languagetool.org/download/${name}.zip";
    sha256 = "1axw8fqg2wlkmv45s71q5pg44sg1s06szpkjhyscy704i7d2jc34";
  };
  buildInputs = [ unzip jdk ];
  installPhase =
  ''
    mkdir -p $out/{bin,share}
    mv * $out/share/.
    for lt in languagetool{,-commandline,-server};do
    cat > $out/bin/$lt <<EXE
    #!${stdenv.shell}
    ${jdk}/bin/java -cp $out/share/ -jar $out/share/$lt.jar $@
    EXE
    chmod +x $out/bin/$lt
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://languagetool.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      edwtjo
      jgeerds
    ];
    descrption = "A proofreading program for English, French German, Polish, and more";
  };
}
