{ stdenv, fetchurl, jre8_headless, makeWrapper }:
  let
    version = "6.4.2";
  in
    stdenv.mkDerivation {
      pname = "flyway";
      inherit version;
      src = fetchurl {
        url = "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${version}/flyway-commandline-${version}.tar.gz";
        sha256 = "1m5i7mw3ml2iaqy09h8nmykn602rwkjfgh2mrmc1gss9q3klj1r8";
      };
      nativeBuildInputs = [ makeWrapper ];
      dontBuild = true;
      dontStrip = true;
      installPhase = ''
        mkdir -p $out/bin $out/share/flyway
        cp -r sql jars drivers conf $out/share/flyway
        install -Dt $out/share/flyway/lib lib/community/*.jar lib/*.jar
        makeWrapper "${jre8_headless}/bin/java" $out/bin/flyway \
          --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
          --add-flags "-classpath '$out/share/flyway/lib/*:$out/share/flyway/drivers/*'" \
          --add-flags "org.flywaydb.commandline.Main" \
          --add-flags "-jarDirs='$out/share/flyway/jars'"
      '';
      meta = with stdenv.lib; {
        description = "Evolve your Database Schema easily and reliably across all your instances";
        longDescription = ''
          The Flyway command-line tool is a standalone Flyway distribution.
          It is primarily meant for users who wish to migrate their database from the command-line
          without having to integrate Flyway into their applications nor having to install a build tool.

          This package is only the Community Edition of the Flyway command-line tool.
        '';
        homepage = "https://flywaydb.org/";
        license = licenses.asl20;
        platforms = platforms.unix;
        maintainers = [ maintainers.cmcdragonkai ];
      };
    }
