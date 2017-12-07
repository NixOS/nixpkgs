{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "1.0.0";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
    ];
    sha256 = "0njwch97g69vzxfqhlaibjwbif2vka68dssddk2jlpqlf94lzq4s";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -s $out/share/sbt/bin/sbt $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.scala-sbt.org/;
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ rickynils ];
    platforms = platforms.unix;
  };
}
