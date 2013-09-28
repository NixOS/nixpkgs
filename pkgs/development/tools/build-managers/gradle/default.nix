{ stdenv, fetchurl, unzip, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gradle-1.8";

  src = fetchurl {
    url = "http://services.gradle.org/distributions/${name}-bin.zip";
    sha256 = "00spxad9b5vddshp02cic0ds8icgb1clknl7494f467x2pxbnhm3";
  };

  installPhase = ''
    mkdir -pv $out
    cp -rv lib $out

    makeWrapper ${jdk}/bin/java $out/bin/gradle \
      --set JAVA_HOME ${jdk} \
      --add-flags "-classpath $out/lib/gradle-launcher-1.8.jar org.gradle.launcher.GradleMain"
  '';

  phases = "unpackPhase installPhase";

  buildInputs = [ unzip jdk makeWrapper ];

  meta = {
    description = "Gradle is an enterprise-grade build system";
    longDescription = ''
      Gradle is a build system which offers you ease, power and freedom.
      You can choose the balance for yourself. It has powerful multi-project
      build support. It has a layer on top of Ivy that provides a 
      build-by-convention integration for Ivy. It gives you always the choice
      between the flexibility of Ant and the convenience of a 
      build-by-convention behavior.
    '';
    homepage = http://www.gradle.org/;
    license = "ASL2.0";
  };
}
