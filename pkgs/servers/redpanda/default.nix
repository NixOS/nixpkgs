{ lib, stdenv, fetchzip }:

let
  version = "21.11.15";
  platform = if stdenv.isLinux then "linux" else "darwin";
  arch = if stdenv.isAarch64 then "arm" else "amd";
in stdenv.mkDerivation rec {
  pname = "redpanda";
  inherit version;

  src = fetchzip {
    url = "https://github.com/redpanda-data/redpanda/releases/download/v${version}/rpk-${platform}-${arch}64.zip";
    sha256 = "sha256-Yf4O7lVcf+nmb0wFTx7jLjUSmdAItoUfPlkhHveI9UY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp rpk $out/bin

    runHook postInstall
  '';

  # stripping somehow completely breaks it
  dontStrip = true;

  meta = with lib; {
    description = "Redpanda is a streaming data platform for developers. Kafka API compatible. 10x faster. No ZooKeeper. No JVM! ";
    license = licenses.bsl11;
    homepage = "https://redpanda.com/";
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
