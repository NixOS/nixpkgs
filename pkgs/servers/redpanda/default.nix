{ lib, stdenv, fetchzip }:

let
  version = "22.3.11";
  platform = if stdenv.isLinux then "linux" else "darwin";
  arch = if stdenv.isAarch64 then "arm" else "amd";
  sha256s = {
    darwin.amd = "sha256-kwAKxFg7BSNInvsQvFqgtpq8EEwSnmDeDyaF5b8L8SQ=";
    darwin.arm = "sha256-kH5Ii672SeAIiRcWuAO3oVJVSBWp+r78RmTiR3BaDbg=";
    linux.amd = "sha256-EKgkRKBrM4+X2YGoP2LpWRHL+fdHu44LYwCZ+O+c5ZY=";
    linux.arm = "sha256-9b4oerRXjUVUYoswJWtnMBJSQDoCKClf673VjDQFUAw=";
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

    ${lib.optionalString stdenv.isLinux ''
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/bin/rpk
    ''}

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
