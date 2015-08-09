{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.8";

  src = fetchurl {
    url = "http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar";
    sha256 = "0n4ivla8s8ygfnf95dj624nhcyganigf7fy0gamgyf31vw1vnw35";
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
