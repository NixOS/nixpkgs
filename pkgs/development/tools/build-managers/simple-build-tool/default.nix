{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "sbt-${version}";
  version = "0.13.0";

  src = fetchurl {
    url = "http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar";
    sha256 = "04s49v5mw4kwz1rmvbf07kq51i2m0lcv60c9i5y524gjj518pk1w";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/sbt << EOF
    #!/bin/sh
    SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M"
    ${jre}/bin/java $SBT_OPTS -jar ${src} "\$@"
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
