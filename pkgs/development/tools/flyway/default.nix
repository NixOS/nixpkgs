{ stdenv, fetchurl, jre_headless, makeWrapper }:
  let
    version = "5.1.1";
  in
    stdenv.mkDerivation {
      name = "flyway-${version}";
      src = fetchurl {
        url = "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.1.1/flyway-commandline-${version}.tar.gz";
        sha256 = "0kdi7m5rwlik0d2rn9s3siqmc83xfkhhsdxw3g7r1mvk2ivscb7f";
      };
      buildInputs = [ makeWrapper ];
      dontBuild = true;
      dontStrip = true;
      installPhase = ''
        mkdir -p $out/bin $out/share/flyway
        cp -r sql jars lib drivers $out/share/flyway
        makeWrapper "${jre_headless}/bin/java" $out/bin/flyway \
          --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
          --add-flags "-cp '$out/share/flyway/lib/*:$out/share/flyway/drivers/*'" \
          --add-flags "org.flywaydb.commandline.Main"
      '';
      meta = with stdenv.lib; {
        description = "Evolve your Database Schema easily and reliably across all your instances";
        homepage = "https://flywaydb.org/";
        license = licenses.asl20;
        platforms = platforms.unix;
        maintainers = [ maintainers.cmcdragonkai ];
      };
    }
