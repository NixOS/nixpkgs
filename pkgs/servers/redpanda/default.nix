{ lib, stdenv, fetchzip }:

let
  version = "22.3.14";
  platform = if stdenv.isLinux then "linux" else "darwin";
  arch = if stdenv.isAarch64 then "arm" else "amd";
  sha256s = {
    darwin.amd = "sha256-X2MrYNP1b3MQc2DfrO3gy7tj3kkKzIfMBejzgFSX1cM=";
    darwin.arm = "sha256-Z1UkfOYm5LFg9N+m33GhL6NGmsWuX46714u74kF0hvc=";
    linux.amd = "sha256-77yBtLd2U/CRFDlkmblzQUiuS/ru8Fh0fM5VVqhdHuo=";
    linux.arm = "sha256-BmjgaVgCjeiJ8jf34lJrTHTbelj01siM7/oqwz/O1i0=";
  };
in stdenv.mkDerivation rec {
  pname = "redpanda";
  inherit version;

  src = fetchzip {
    url = "https://github.com/redpanda-data/redpanda/releases/download/v${version}/rpk-${platform}-${arch}64.zip";
    sha256 = sha256s.${platform}.${arch};
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    homepage = "https://redpanda.com/";
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
