{ stdenv, fetchurl, jre_headless, makeWrapper }:
  let
    version = "5.2.4";
  in
    stdenv.mkDerivation {
      name = "flyway-${version}";
      src = fetchurl {
        url = "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${version}/flyway-commandline-${version}.tar.gz";
        sha256 = "16ia6nlvj4cgmdkn66bjg73h5vah82hpzk9mf0n5kmqnwcaa8hmc";
      };
      nativeBuildInputs = [ makeWrapper ];
      dontBuild = true;
      dontStrip = true;
      installPhase = ''
        mkdir -p $out/bin $out/share/flyway
        cp -r sql jars drivers conf $out/share/flyway
        cp -r lib/community $out/share/flyway/lib
        makeWrapper "${jre_headless}/bin/java" $out/bin/flyway \
          --add-flags "-Djava.security.egd=file:/dev/../dev/urandom" \
          --add-flags "-classpath '$out/share/flyway/lib/*:$out/share/flyway/drivers/*'" \
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
