{ lib, stdenv, fetchurl, jre, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "polylith";
  version = "0.1.0-alpha9";

  src = fetchurl {
    url = "https://github.com/polyfy/polylith/releases/download/v${version}/poly-${version}.jar";
    sha256 = "0mjn0fibj7z8wihk5frhyd5ai2bmzm909701sphjs7j9lgg0gc4k";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cat > "$out/bin/poly" <<EOF
    #!${runtimeShell}
    ARGS=""
    while [ "\$1" != "" ] ; do
      ARGS="\$ARGS \$1"
      shift
    done
    exec "${jre}/bin/java" "-jar" "${src}" \$ARGS
    EOF
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
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
}
