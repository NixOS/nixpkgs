{ stdenv, fetchurl, unzip, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gradle-2.8";

  src = fetchurl {
    url = "http://services.gradle.org/distributions/${name}-bin.zip";
    sha256 = "1jq3m6ihvcxyp37mwsg3i8li9hd6rpv8ri8ih2mgvph4y71bk3d8";
  };

  installPhase = ''
    mkdir -pv $out/gradle
    cp -rv lib $out/gradle

    gradle_launcher_jar=$(echo $out/gradle/lib/gradle-launcher-*.jar)
    test -f $gradle_launcher_jar
    makeWrapper ${jdk}/bin/java $out/bin/gradle \
      --set JAVA_HOME ${jdk} \
      --add-flags "-classpath $gradle_launcher_jar org.gradle.launcher.GradleMain"
  '';

  phases = "unpackPhase installPhase";

  buildInputs = [ unzip jdk makeWrapper ];

  meta = {
    description = "Enterprise-grade build system";
    longDescription = ''
      Gradle is a build system which offers you ease, power and freedom.
      You can choose the balance for yourself. It has powerful multi-project
      build support. It has a layer on top of Ivy that provides a 
      build-by-convention integration for Ivy. It gives you always the choice
      between the flexibility of Ant and the convenience of a 
      build-by-convention behavior.
    '';
    homepage = http://www.gradle.org/;
    license = stdenv.lib.licenses.asl20;
  };
}
