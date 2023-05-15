{ stdenvNoCC
, lib
, fetchurl
, autoPatchelfHook
, php
}:

let
  soFile = {
    "8.0" = "tideways-php-8.0.so";
    "8.1" = "tideways-php-8.1.so";
    "8.2" = "tideways-php-8.2.so";
  }.${lib.versions.majorMinor php.version} or (throw "Unsupported PHP version.");
  version = "5.5.18";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/extension/${version}/tideways-php-${version}-x86_64.tar.gz";
      hash = "sha256-ZKx9sVaz+XFz8fYRgYXXg6ggwfjT7LqrFaSQuSaPLSw=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/extension/${version}/tideways-php-${version}-arm64.tar.gz";
      hash = "sha256-dX9fSUM0DIAIr1EITsRPx2GZ8zmGSaGn+IZqSQWn66M=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/tideways/extension/${version}/tideways-php-${version}-macos-arm.tar.gz";
      hash = "sha256-cDYkd1aP047bwBeJeEgbb+7QSwuNNGZ7d+8BTdMDMBA=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tideways-php";
  extensionName = "tideways";
  inherit version;

  src = sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported platform for tideways-cli: ${stdenvNoCC.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenvNoCC.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    install -D ${soFile} $out/lib/php/extensions/tideways.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tideways PHP Probe";
    homepage = "https://tideways.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  };
})
