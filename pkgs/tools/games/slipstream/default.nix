{ lib, fetchFromGitHub, makeWrapper, maven, jdk }:
let
  mavenWithJdk = maven.override { inherit jdk; };
in
mavenWithJdk.buildMavenPackage rec {
  pname = "slipstream";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "Vhati";
    repo = "Slipstream-Mod-Manager";
    rev = "v${version}";
    hash = "sha256-F+o94Oh9qxVdfgwdmyOv+WZl1BjQuzhQWaVrAgScgIU=";
  };

  mvnHash = "sha256-zqXbLnLmTZHzwH+vgGASR7Jsz1t173DmQMIe2R6B6Ic=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    install -Dm644 target/ftl-mod-manager-${version}.jar $out/share/java
    install -Dm644 target/modman.jar $out/share/java

    # slipstream is very finniky about having specific
    # folders at startup, so wrapper creates them for it.
    # this is because slipstream expects to be started from
    # archive it comes from, but we can't do that since
    # we need the mods directory to be writable.
    # see: https://github.com/Vhati/Slipstream-Mod-Manager/blob/85cad4ffbef8583d908b189204d7d22a26be43f8/src/main/java/net/vhati/modmanager/cli/SlipstreamCLI.java#L105
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
      --run '_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/slipstream"' \
      --run 'mkdir -p $_dir/{mods,backup}' \
      --run 'cd $_dir' \
      --append-flags "-jar $out/share/java/modman.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mod manager for FTL: Faster Than Light";
    homepage = "https://github.com/Vhati/Slipstream-Mod-Manager";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ mib ];
    mainProgram = "slipstream";
  };
}
