{ lib, fetchFromGitHub, stdenv, makeWrapper, buildMaven, maven, jdk8 }:
let
  jdk = jdk8;
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

  mvnHash = "sha256-oDtUitsfZPiDtyfzzw1yMNBCKyP6rHczKZT/SPPJYGE=";

  nativeBuildInputs = [ mavenWithJdk makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    install -Dm644 target/ftl-mod-manager-${version}.jar $out/share/java
    install -Dm644 target/modman.jar $out/share/java

    makeWrapper ${wrapper} $out/bin/${pname} \
      --suffix PATH : ${lib.makeBinPath [ jdk ]} \
      --set jar_file "$out/share/java/modman.jar"

    runHook postInstall
  '';

  wrapper = ./wrapper.sh;

  meta = with lib; {
    description = "A mod manager for FTL: Faster Than Light";
    homepage = "https://github.com/Vhati/Slipstream-Mod-Manager";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mib ];
  };
}
