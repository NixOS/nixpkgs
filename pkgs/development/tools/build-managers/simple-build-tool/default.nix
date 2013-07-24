{ stdenv, versionedDerivation, fetchurl, version ? "xsbt-0.12.3" }:

let

      description = "A build tool for Scala";
      longDescription = name: ''
        ${name} is a simple build tool for Scala projects that aims to do the
        basics well.

        This package is the sbt launcher which automatically manages
        and downloads dependencies, including the SBT package and the
        Scala compiler.
      '';

      metaSBT = {
        inherit description;
        longDescription = longDescription "sbt";
        homepage = http://code.google.com/p/simple-build-tool/;
        license = "bsd";
      };

      metaXSBT = {
        inherit description;
        longDescription = longDescription "xsbt";
        homepage = https://github.com/harrah/xsbt;
        license = "bsd";
      };

in

# Depends on a JRE at runtime.

versionedDerivation "simple-build-tool" version {
  "0.7.3" = let version = "0.7.3"; in {
    name = "simple-build-tool-${version}";
    src = fetchurl {
      url = "http://simple-build-tool.googlecode.com/files/sbt-launch-${version}.jar";
      sha256 = "1nciifzf00cs54a4h57a7v1hyklm5vgln0sscmz5kzv96ggphs6k";
    };
    meta = metaSBT;
  };

  "0.7.7" = let version = "0.7.7"; in {
    name = "simple-build-tool-${version}";
    src = fetchurl {
      url = "http://simple-build-tool.googlecode.com/files/sbt-launch-${version}.jar";
      # sha256 = "1nciifzf00cs54a4h57a7v1hyklm5vgln0sscmz5kzv96ggphs6j";
      sha256 = "2720b033012a7509f7fbdfddfa69c07b105452a6f95bc410cb7dc34c1594ab3d";
    };
    meta = metaSBT;
  };

  "xsbt-0.11.2" = let version = "0.11.2"; in { # scala 2.9
    name = "xsbt-${version}";

    # scala needs much more PermGen space
    javaArgs = "-Xmx1024M";
    # from https://github.com/harrah/xsbt/wiki/Getting-Started-Setup
    src = fetchurl {
      url = http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-tools.sbt/sbt-launch/0.11.2/sbt-launch.jar;
      sha256 = "14fbzvb1s66wpbqznw65a7nn27qrq1i9pd7wlbydv8ffl49d262n";
    };
    meta = metaXSBT;
  };

  "xsbt-0.12.3" = let version = "0.12.3"; in {
    name = "xsbt-${version}";

    # Recommended java options from sbt Getting started guide
    javaArgs = "-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M";
    # from https://github.com/harrah/xsbt/wiki/Getting-Started-Setup
    src = fetchurl {
      url = http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.12.3/sbt-launch.jar;
      sha256 = "11r26abjzmnmpn65ndbq60qg31s3ichkvzpmxyrq941s1n1dbxgh";
    };
    meta = metaXSBT;
  };
}
{

  installPhase = ''
    mkdir -pv "$out/lib/java"
    cp $src "$out/lib/java/sbt-launch-${version}.jar"
    mkdir -p "$out/bin"
    cat > "$out/bin/sbt" <<EOF
    #! /bin/sh
    exec java $javaArgs -jar $out/lib/java/sbt-launch-${version}.jar "\$@"
    EOF
    chmod u+x "$out/bin/sbt"
  '';

  phases = "installPhase";
}
