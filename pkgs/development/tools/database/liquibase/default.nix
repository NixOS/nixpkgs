{ stdenv, fetchurl, jre, makeWrapper
, mysqlSupport ? true, mysql_jdbc ? null }:

assert mysqlSupport -> mysql_jdbc != null;

with stdenv.lib;
let
  extraJars = optional mysqlSupport mysql_jdbc;
in

stdenv.mkDerivation rec {
  pname = "liquibase";
  version = "3.10.2";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "19wdflkp4n0pds4lkliagg8l5kf9db5f5bn39akhwasc4yj0g7j2";
  };

  buildInputs = [ jre makeWrapper ];

  unpackPhase = ''
    tar xfz ${src}
  '';

  installPhase =
    let addJars = dir: ''
      for jar in ${dir}/*.jar; do
        CP="\$CP":"\$jar"
      done
    '';
    in ''
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
      ${concatStringsSep "\n" (map (p: addJars "${p}/share/java") extraJars)}

      ${getBin jre}/bin/java -cp "\$CP" \$JAVA_OPTS \
        liquibase.integration.commandline.Main \''${1+"\$@"}
      EOF
      chmod +x $out/bin/liquibase
  '';

  meta = {
    description = "Version Control for your database";
    homepage = "http://www.liquibase.org/";
    changelog = "https://raw.githubusercontent.com/liquibase/liquibase/v${version}/changelog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
  };
}
