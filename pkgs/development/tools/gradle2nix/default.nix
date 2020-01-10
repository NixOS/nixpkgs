{ callPackage, jre, makeWrapper }:

rec {
  buildGradle = callPackage ./gradle-env.nix {};

  gradle2nix = buildGradle {
    envSpec = ./gradle-env.json;
    src = import ./fetch-source.nix {};
    gradleFlags = [ "installDist" ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out
      cp -r app/build/install/gradle2nix/* $out/
      wrapProgram $out/bin/gradle2nix \
        --set JAVA_HOME ${jre}
    '';
  };
}
