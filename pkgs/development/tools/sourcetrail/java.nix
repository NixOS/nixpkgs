{ pkgs, javaPackages }:

let
  javaIndexer = javaPackages.mavenbuild {
    name = "sourcetrail-java-indexer-${pkgs.sourcetrail.version}";
    src = pkgs.sourcetrail.src;
    m2Path = "com/sourcetrail/java-indexer";

    # This doesn't include all required dependencies. We still rely on binary
    # copies of maven packages included in the source repo for building.
    mavenDeps = with javaPackages; [
      mavenCompiler_3_2
      plexusCompilerApi_2_4
      plexusCompilerJavac_2_4
      plexusCompilerManager_2_4
    ];

    meta = {
      description = "Java indexer for Sourcetrail";
    };
  };
in
javaIndexer.overrideAttrs (drv: {
  postUnpack = ''
    export sourceRoot=''${sourceRoot}/java_indexer
  '';
})
