{ lib, fetchFromGitHub, stdenv, makeWrapper, buildMaven, maven, jdk8 }:
let
  settings = (buildMaven ./project-info.json).settings;
  jdk = jdk8;
in
stdenv.mkDerivation rec {
  pname = "slipstream";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "Vhati";
    repo = "Slipstream-Mod-Manager";
    rev = "v${version}";
    sha256 = "sha256-F+o94Oh9qxVdfgwdmyOv+WZl1BjQuzhQWaVrAgScgIU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ (maven.override { inherit jdk; }) ];

  buildPhase = "mvn --offline --settings=${settings} package";

  installPhase = ''
    mkdir -p $out/share/java
    install -Dm644 target/ftl-mod-manager-${version}.jar $out/share/java
    install -Dm644 target/modman.jar $out/share/java

    makeWrapper ${wrapper} $out/bin/${pname} \
      --suffix PATH : ${lib.makeBinPath [ jdk ]} \
      --set jar_file "$out/share/java/modman.jar"
  '';

  wrapper = ./wrapper.sh;

  meta = with lib; {
    description = "A mod manager for FTL: Faster Than Light";
    homepage = "https://github.com/Vhati/Slipstream-Mod-Manager";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mib ];
  };
}
