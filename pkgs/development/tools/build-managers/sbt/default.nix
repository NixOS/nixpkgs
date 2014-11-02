{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.6";

  src = fetchurl {
    url = "http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar";
    sha256 = "928ddfdee8aa05c297e7252699b211748139bbb3b2d25c22e590c939352c3bff";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/sbt << EOF
    #! ${stdenv.shell}
    ${jre}/bin/java \$SBT_OPTS -jar ${src} "\$@"
    EOF
    chmod +x $out/bin/sbt
  '';

  meta = {
    homepage = http://www.scala-sbt.org/;
    license = stdenv.lib.licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}
