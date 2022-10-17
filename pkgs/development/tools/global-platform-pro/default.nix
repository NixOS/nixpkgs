{ lib, stdenv, fetchFromGitHub, jdk8, maven, makeWrapper, jre8_headless, pcsclite }:

let jdk = jdk8; jre_headless = jre8_headless; in
# TODO: This is quite a bit of duplicated logic with gephi. Factor it out?
stdenv.mkDerivation rec {
  pname = "global-platform-pro";
  version = "18.09.14";
  GPPRO_VERSION = "18.09.14-0-gb439b52"; # git describe --tags --always --long --dirty

  src = fetchFromGitHub {
    owner = "martinpaljak";
    repo = "GlobalPlatformPro";
    rev = version;
    sha256 = "1vws6cbgm3mrwc2xz9j1y262vw21x3hjc9m7rqc4hn3m7gjpwsvg";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;
    nativeBuildInputs = [ jdk maven ];
    installPhase = ''
      # Download the dependencies
      while ! mvn package "-Dmaven.repo.local=$out/.m2" -Dmaven.wagon.rto=5000; do
        echo "timeout, restart maven to continue downloading"
      done

      # And keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files
      # with lastModified timestamps inside
      find "$out/.m2" -type f \
        -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' \
        -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1qwgvz6l5wia8q5824c9f3iwyapfskljhqf1z09fw6jjj1jy3b15";
  };

  nativeBuildInputs = [ jdk maven makeWrapper ];

  buildPhase = ''
    cp -dpR "${deps}/.m2" ./
    chmod -R +w .m2
    mvn package --offline -Dmaven.repo.local="$(pwd)/.m2"
  '';

  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp target/gp.jar "$out/share/java"
    makeWrapper "${jre_headless}/bin/java" "$out/bin/gp" \
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
