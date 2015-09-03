{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.9";

  src = fetchurl {
    url = "http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar";
    sha256 = "04k411gcrq35ayd2xj79bcshczslyqkicwvhkf07hkyr4j3blxda";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/sbt << EOF
    #! ${stdenv.shell}
    if [ ! -v JAVA_HOME ]; then
        export JAVA_HOME="${jre.home}"
    fi
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
