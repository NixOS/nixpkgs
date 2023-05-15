{ stdenvNoCC
, lib
, fetchurl
}:

let
  version = "1.8.28";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/daemon/${version}/tideways-daemon_linux_amd64-${version}.tar.gz";
      hash = "sha256-t84FP09LqmZbaJF4Jbd9bzcXt2G9uhY/ITeV5F3TWCY=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/daemon/${version}/tideways-daemon_linux_aarch64-${version}.tar.gz";
      hash = "sha256-gMn9wXg2s8lFkhgDbajbCDvlIDwB0Sz1PcS/KOIzE28=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/daemon/${version}/tideways-daemon_macos_arm64-${version}.tar.gz";
      hash = "sha256-p+WKdBG1K3apeXfSqnpd2yGj87MWVTd5oJoFTIZAGL8=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tideways-daemon";
  inherit version;

  src = sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported platform for tideways-daemon: ${stdenvNoCC.hostPlatform.system}");

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tideways-daemon $out/bin/tideways-daemon
    chmod +x $out/bin/tideways-daemon

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tideways Profiler daemon";
    homepage = "https://tideways.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  };
})
