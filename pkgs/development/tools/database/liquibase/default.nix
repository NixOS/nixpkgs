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
  version = "3.6.2";

  src = fetchurl {
    url = "https://github.com/liquibase/liquibase/releases/download/${pname}-parent-${version}/${name}-bin.tar.gz";
    sha256 = "199ybjk0xxsg04v5x5l4arljmzj96hxva6ym6bp7av7dny0nqvfx";
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

      # Clean up documentation.
      mkdir -p $out/share/doc/${name}
      mv $out/LICENSE.txt \
         $out/README.txt \
         $out/share/doc/${name}

      # Remove silly files.
      rm $out/liquibase.bat $out/liquibase.spec

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
    homepage = http://www.liquibase.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
  };
}
