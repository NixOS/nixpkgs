{ lib
, stdenv
, fetchurl
, gitUpdater
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
  version = "4.23.0";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-mIuHNNo/L5h2RvpTN0jZt6ri+Il0H9aSL4auOjIepjU=";
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
      mv ./{lib,licenses,internal/lib/liquibase-core.jar,internal/lib/postgresql.jar,internal/lib/picocli.jar} $out/

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
      CP=""
      ${addJars "$out/lib"}
      ${addJars "$out"}
      ${lib.concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}

      ${lib.getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
        liquibase.integration.commandline.LiquibaseCommandLine \''${1+"\$@"}
      EOF
      chmod +x $out/bin/liquibase
    '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/liquibase/liquibase";
    rev-prefix = "v";
    # The latest versions are in the 4.xx series.  I am not sure where
    # 10.10.10 and 5.0.0 came from, though it appears like they are
    # for the commercial product.
    ignoredVersions = "10.10.10|5.0.0|.*-beta.*";
  };

  meta = with lib; {
    description = "Version Control for your database";
    homepage = "https://www.liquibase.org/";
    changelog = "https://raw.githubusercontent.com/liquibase/liquibase/v${version}/changelog.txt";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ jsoo1 ];
    platforms = with platforms; unix;
  };
}
