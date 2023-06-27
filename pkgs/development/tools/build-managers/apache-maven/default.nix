{ lib
, stdenvNoCC
, fetchurl
, jdk
, makeWrapper
, callPackage
}:

assert jdk != null;

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apache-maven";
  version = "3.9.2";

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${finalAttrs.version}/binaries/${finalAttrs.pname}-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-gJ7zIgxtF5GVwGwyTLmm002Oy6Vmxc/Y64MWe8A0EX0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/maven
    cp -r ${finalAttrs.pname}-${finalAttrs.version}/* $out/maven

    makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      --set-default JAVA_HOME "${jdk}"
    makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      --set-default JAVA_HOME "${jdk}"

    runHook postInstall
  '';

  passthru.buildMavenPackage = callPackage ./build-package.nix {
    maven = finalAttrs.finalPackage;
  };

  meta = with lib; {
    mainProgram = "mvn";
    description = "Build automation tool (used primarily for Java projects)";
    homepage = "https://maven.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cko ];
  };
})
