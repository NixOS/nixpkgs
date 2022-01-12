{ lib, stdenv, fetchurl, jdk, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "polylith";
  version = "0.2.13-alpha";

  src = fetchurl {
    url = "https://github.com/polyfy/polylith/releases/download/v${version}/poly-${version}.jar";
    sha256 = "sha256-iLN92qurc8+D0pt7Hwag+TFGoeFl9DvEeS67sKmmoSI=";
  };

  dontUnpack = true;

  passAsFile = [ "polyWrapper" ];
  polyWrapper = ''
    #!${runtimeShell}
    ARGS=""
    while [ "$1" != "" ] ; do
      ARGS="$ARGS $1"
      shift
    done
    exec "${jdk}/bin/java" "-jar" "${src}" $ARGS
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp "$polyWrapperPath" $out/bin/poly
    chmod a+x $out/bin/poly

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/poly help | fgrep -q '${version}'

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A tool used to develop Polylith based architectures in Clojure";
    homepage = "https://github.com/polyfy/polylith";
    license = licenses.epl10;
    maintainers = with maintainers; [ ericdallo jlesquembre ];
    platforms = jdk.meta.platforms;
  };
}
