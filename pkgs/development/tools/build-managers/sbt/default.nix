{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.9";

  src = fetchurl {
    url = "https://dl.bintray.com/sbt/native-packages/sbt/${version}/${name}.tgz";
    sha256 = "148f2801f2993773de6f8859fe0e6520fcabe649d66bb316e13aff8b2fd7f504";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -s $out/share/sbt/bin/sbt $out/bin/
  '';

  meta = {
    homepage = http://www.scala-sbt.org/;
    license = stdenv.lib.licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}
