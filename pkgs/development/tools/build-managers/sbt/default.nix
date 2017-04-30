{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.15";

  src = fetchurl {
    url = "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz";
    sha256 = "1vvsxpg1fwfzv3mcin69gnj44v6p7kfx3z9cm761sx01qbbp7q5n";
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
