{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "1.1.1";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
      "https://cocl.us/sbt-${version}.tgz"
    ];
    sha256 = "0fy04mnnrbdm7kfnjh6sv1q3g6wqzvwyf1p43f36rw3qalap544a";
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
    maintainers = with maintainers; [ nequissimus rickynils ];
    platforms = platforms.unix;
  };
}
