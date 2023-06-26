{ lib, fetchFromGitHub, jdk8, maven, makeWrapper, jre8_headless, pcsclite }:

let
  mavenJdk8 = maven.override {
    jdk = jdk8;
  };
in
mavenJdk8.buildMavenPackage rec {
  pname = "global-platform-pro";
  version = "18.09.14";
  GPPRO_VERSION = "18.09.14-0-gb439b52"; # git describe --tags --always --long --dirty

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
    rev = version;
    sha256 = "1vws6cbgm3mrwc2xz9j1y262vw21x3hjc9m7rqc4hn3m7gjpwsvg";
  };

  mvnHash = "sha256-rRLsCTY3fEAvGRDvNXqpjac2Gb5fdlyhK2wTK5CVN9k=";

  nativeBuildInputs = [ jdk8 mavenJdk8 makeWrapper ];

  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp target/gp.jar "$out/share/java"
    makeWrapper "${jre8_headless}/bin/java" "$out/bin/gp" \
      --add-flags "-jar '$out/share/java/gp.jar'" \
      --prefix LD_LIBRARY_PATH : "${pcsclite.out}/lib"
  '';

  meta = with lib; {
    description = "Command-line utility for managing applets and keys on Java Cards";
    longDescription = ''
      This command-line utility can be used to manage applets and keys
      on Java Cards. It is made available as the `gp` executable.

      The executable requires the PC/SC daemon running for correct execution.
      If you run NixOS, it can be enabled with `services.pcscd.enable = true;`.
    '';
    homepage = "https://github.com/martinpaljak/GlobalPlatformPro";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gp";
    platforms = platforms.all;
  };
}
