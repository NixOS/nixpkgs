{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.13";

  src = fetchurl {
    url = "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz";
    sha256 = "0ygrz92qkzasj6fps1bjg7wlgl69867jjjc37yjadib0l8hkvl20";
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
