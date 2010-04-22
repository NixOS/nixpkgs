args: with args;

# at runtime, need jdk

stdenv.mkDerivation rec {
  name = "gradle-0.8";

  src = fetchurl {
    url = "http://dist.codehaus.org/gradle/gradle-0.8-bin.zip";
    sha256 = "940e623ea98e40ea9ad398770a6ebb91a61c0869d394dda81aa86b0f4f0025e7";
  };

  installPhase = ''
    ensureDir $out
    rm bin/*.bat
    mv * $out
  '';

  phases = "unpackPhase installPhase";

  buildInputs = [unzip];

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
