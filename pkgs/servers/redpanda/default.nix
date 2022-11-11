{ lib, stdenv, fetchzip }:

let
  version = "22.2.7";
  platform = if stdenv.isLinux then "linux" else "darwin";
  arch = if stdenv.isAarch64 then "arm" else "amd";
  sha256s = {
    darwin.amd = "sha256-AXk3aP1SGiHTfHTCBRTagX0DAVmdcVVIkxWaTnZxB8g=";
    darwin.arm = "sha256-pvOVvNc8lZ2d2fVZVYWvumVWYpnLORNY/3o1t4BN2N4=";
    linux.amd = "sha256-hUChGYimCFXEvSxb49QgPo/LYlef0ZMVhKNy9i3SpVA=";
    linux.arm = "sha256-WHjYAbytiu747jFqN0KZ/CkIwAVI7fb32ywtRiQOBm8=";
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
