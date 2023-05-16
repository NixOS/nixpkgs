{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "4.23.1";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-uWZ9l6C6QlVHqp/ma6/sz07zuCHpGucy7GhNDq8v1/U=";
=======
  version = "4.9.0";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-1InRJzHqikm6Jd7z54TW6JFn3FO0LtStehWNaC+rdw8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      mv ./{lib,licenses} $out/

      mkdir -p $out/internal/lib
      mv ./internal/lib/*.jar $out/internal/lib/
=======
      mv ./{lib,licenses,liquibase.jar} $out/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
      CP=""
      ${addJars "$out/internal/lib"}
      ${addJars "$out/lib"}
      ${addJars "$out"}
      ${lib.concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}
      ${lib.getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
      liquibase.integration.commandline.LiquibaseCommandLine \''${1+"\$@"}
=======
      CP="$out/liquibase.jar"
      ${addJars "$out/lib"}
      ${lib.concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}

      ${lib.getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
        liquibase.integration.commandline.LiquibaseCommandLine \''${1+"\$@"}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      EOF
      chmod +x $out/bin/liquibase
    '';

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://github.com/liquibase/liquibase";
    rev-prefix = "v";
    # The latest versions are in the 4.xx series.  I am not sure where
    # 10.10.10 and 5.0.0 came from, though it appears like they are
    # for the commercial product.
    ignoredVersions = "10.10.10|5.0.0|.*-beta.*";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Version Control for your database";
    homepage = "https://www.liquibase.org/";
    changelog = "https://raw.githubusercontent.com/liquibase/liquibase/v${version}/changelog.txt";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ jsoo1 ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = with platforms; unix;
  };
}
