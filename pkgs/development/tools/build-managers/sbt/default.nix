{ stdenv, fetchurl, jre, bc }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "1.0.3";

  src = fetchurl {
    urls = [
      "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
      "https://cocl.us/sbt-${version}.tgz"
    ];
    sha256 = "041cv25gxqsi3rlglw5d8aqgdzb6y5ak3f52dwqvzrrj854vyx13";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts

    substituteInPlace bin/sbt-launch-lib.bash \
      --replace "| bc)" "| ${bc}/bin/bc)"
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
