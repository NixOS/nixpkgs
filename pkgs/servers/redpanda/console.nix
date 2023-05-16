{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "redpandaconsole";
  version = "2.2.3";

  src = fetchzip {
    url = "https://github.com/redpanda-data/console/releases/download/v${version}/redpanda_console_${version}_linux_64-bit.tar.gz";
    sha256 = "sha256-ilSQy/8CPh0GpZIAA2w8NPwscNYLfLTdLWIss3f1ET4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp redpanda-console $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    # TODO: Fill out meta
    platforms = platforms.linux;
    disabled = stdenv.isAarch64; # TODO: Enable for other architectures
  };

}
