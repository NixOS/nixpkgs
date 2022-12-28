{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
, mysqlSupport ? true
, mysql_jdbc
, postgresqlSupport ? true
, postgresql_jdbc
, redshiftSupport ? true
, redshift_jdbc
, liquibase_redshift_extension
}:

let
  extraJars =
    lib.optional mysqlSupport mysql_jdbc
    ++ lib.optional postgresqlSupport postgresql_jdbc
    ++ lib.optionals redshiftSupport [
      redshift_jdbc
      liquibase_redshift_extension
    ];
in

stdenv.mkDerivation rec {
  pname = "liquibase";
  version = "4.9.0";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-1InRJzHqikm6Jd7z54TW6JFn3FO0LtStehWNaC+rdw8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  unpackPhase = ''
    tar xfz ${src}
  '';

  installPhase =
    let addJars = dir: ''
      for jar in ${dir}/*.jar; do
        CP="\$CP":"\$jar"
      done
    '';
    in
    ''
      mkdir -p $out
      mv ./{lib,licenses,liquibase.jar} $out/

      mkdir -p $out/share/doc/${pname}-${version}
      mv LICENSE.txt \
         README.txt \
         ABOUT.txt \
         changelog.txt \
         $out/share/doc/${pname}-${version}

      mkdir -p $out/bin
      # there’s a lot of escaping, but I’m not sure how to improve that
      cat > $out/bin/liquibase <<EOF
      #!/usr/bin/env bash
      # taken from the executable script in the source
      CP="$out/liquibase.jar"
      ${addJars "$out/lib"}
      ${lib.concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}

      ${lib.getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
        liquibase.integration.commandline.LiquibaseCommandLine \''${1+"\$@"}
      EOF
      chmod +x $out/bin/liquibase
    '';

  meta = with lib; {
    description = "Version Control for your database";
    homepage = "https://www.liquibase.org/";
    changelog = "https://raw.githubusercontent.com/liquibase/liquibase/v${version}/changelog.txt";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
