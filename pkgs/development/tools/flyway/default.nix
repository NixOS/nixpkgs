{ lib, stdenv, fetchurl, jre_headless, makeWrapper, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "flyway";
  version = "9.22.0";
  src = fetchurl {
    url = "mirror://maven/org/flywaydb/flyway-commandline/${finalAttrs.version}/flyway-commandline-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-vdg66ETDfa0WG1TrRWJ9XpMSCE9sd5GlYAJY2TERC5Y=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    mkdir -p $out/bin $out/share/flyway
    cp -r sql jars drivers conf $out/share/flyway
    install -Dt $out/share/flyway/lib lib/community/*.jar lib/*.jar lib/aad/*.jar lib/oracle_wallet/*.jar
    makeWrapper "${jre_headless}/bin/java" $out/bin/flyway \
      --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
      --add-flags "-classpath '$out/share/flyway/lib/*:$out/share/flyway/drivers/*'" \
      --add-flags "org.flywaydb.commandline.Main" \
      --add-flags "-jarDirs='$out/share/flyway/jars'"
  '';
  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };
  meta = with lib; {
    description = "Evolve your Database Schema easily and reliably across all your instances";
    longDescription = ''
      The Flyway command-line tool is a standalone Flyway distribution.
      It is primarily meant for users who wish to migrate their database from the command-line
      without having to integrate Flyway into their applications nor having to install a build tool.

      This package is only the Community Edition of the Flyway command-line tool.
    '';
    downloadPage = "https://github.com/flyway/flyway";
    homepage = "https://flywaydb.org/";
    changelog = "https://documentation.red-gate.com/fd/release-notes-for-flyway-engine-179732572.html";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.cmcdragonkai ];
  };
})
