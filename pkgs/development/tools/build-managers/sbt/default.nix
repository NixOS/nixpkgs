{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.16";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz"
      "https://cocl.us/sbt01316tgz"
    ];
    sha256 = "033nvklclvbirhpsiy28d3ccmbm26zcs9vb7j8jndsc1ln09awi2";
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
