{ stdenv, fetchurl, writeText, jre, makeWrapper, fetchMavenArtifact
, mysqlSupport ? true, mysql_jdbc ? null }:

assert mysqlSupport -> mysql_jdbc != null;

with stdenv.lib;
let
  extraJars = optional mysqlSupport mysql_jdbc;

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "liquibase";
  version = "3.5.3";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/${pname}-parent-${version}/${name}-bin.tar.gz";
    sha256 = "04cpnfycv0ms70d70w8ijqp2yacj2svs7v3lk99z1bpq3rzx51gv";
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
      mkdir -p $out/{bin,lib,sdk}
      mv ./* $out/

      # we provide our own script
      rm $out/liquibase

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
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus profpatsch ];
    platforms = with platforms; unix;
  };
}
