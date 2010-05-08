{ stdenv, fetchurl }:

# Depends on a JRE at runtime.

let
  version = "0.7.3";
in
  stdenv.mkDerivation rec {
    name = "simple-build-tool-${version}";
    src = fetchurl {
      url = "http://simple-build-tool.googlecode.com/files/sbt-launch-${version}.jar";
      sha256 = "1nciifzf00cs54a4h57a7v1hyklm5vgln0sscmz5kzv96ggphs6k";
    };

    installPhase = ''
      mkdir -pv "$out/lib/java"
      cp $src "$out/lib/java/sbt-launch-${version}.jar"
      mkdir -p "$out/bin"
      cat > "$out/bin/sbt" <<EOF
      #! /bin/sh
      exec java -jar $out/lib/java/sbt-launch-${version}.jar "\$@"
      EOF
      chmod u+x "$out/bin/sbt"
    '';

    phases = "installPhase";

    meta = {
      description = "A build tool for Scala";
      longDescription = ''
        sbt is a simple build tool for Scala projects that aims to do the
        basics well.

	This package is the sbt launcher which automatically manages
	and downloads dependencies, including the SBT package and the
	Scala compiler.
      '';
      homepage = http://code.google.com/p/simple-build-tool/;
      license = "bsd";
    };
  }
