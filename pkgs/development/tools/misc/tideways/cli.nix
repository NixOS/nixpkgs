{ stdenvNoCC
, lib
, fetchurl
}:

let
  version = "1.0.6";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${version}/tideways-cli_linux_amd64-${version}.tar.gz";
      hash = "sha256-ZCYR4ewzsgV5SonpdCrk+qcFNRPt+GDXHAmvJxsCUxI=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${version}/tideways-cli_linux_arm64-${version}.tar.gz";
      hash = "sha256-Ru87Iwwaqv3lLtyRYV7RZFlCrnguNbpMqQQYvKLeO7E=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${version}/tideways-cli_macos_amd64-${version}.tar.gz";
      hash = "sha256-92kj2sSzChgmzpA1ZzHLAl31jACddBnOId2sJ5A8E9w=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${version}/tideways-cli_macos_arm64-${version}.tar.gz";
      hash = "sha256-cAjAzKAZIv92SGsgwOkoTt6tA3W93B4pDHnwTEGWt1A=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tideways-cli";
  inherit version;

  src = sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported platform for tideways-cli: ${stdenvNoCC.hostPlatform.system}");

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tideways $out/bin/tideways
    chmod +x $out/bin/tideways

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tideways Profiler CLI";
    homepage = "https://tideways.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
