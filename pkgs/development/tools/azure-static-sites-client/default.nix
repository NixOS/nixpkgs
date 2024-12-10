{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  curl,
  icu70,
  libkrb5,
  lttng-ust,
  openssl,
  zlib,
  azure-static-sites-client,
  # "latest", "stable" or "backup"
  versionFlavor ? "stable",
}:
let
  versions = lib.importJSON ./versions.json;
  flavor = with lib; head (filter (x: x.version == versionFlavor) versions);
  fetchBinary =
    runtimeId:
    fetchurl {
      url = flavor.files.${runtimeId}.url;
      sha256 = flavor.files.${runtimeId}.sha;
    };
  sources = {
    "x86_64-linux" = fetchBinary "linux-x64";
    "x86_64-darwin" = fetchBinary "osx-x64";
  };
in
stdenv.mkDerivation {
  pname = "StaticSitesClient-${versionFlavor}";
  version = flavor.buildId;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    icu70
    libkrb5
    lttng-ust
    openssl
    stdenv.cc.cc.lib
    zlib
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m755 "$src" -D "$out/bin/StaticSitesClient"

    for icu_lib in 'icui18n' 'icuuc' 'icudata'; do
      patchelf --add-needed "lib''${icu_lib}.so.${
        with lib; head (splitVersion (getVersion icu70.name))
      }" "$out/bin/StaticSitesClient"
    done

    patchelf --add-needed 'libgssapi_krb5.so' \
             --add-needed 'liblttng-ust.so'   \
             --add-needed 'libssl.so.3'     \
             "$out/bin/StaticSitesClient"

    runHook postInstall
  '';

  # Stripping kills the binary
  dontStrip = true;

  # Just make sure the binary executes successfully
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/StaticSitesClient version

    runHook postInstallCheck
  '';

  passthru = {
    # Create tests for all flavors
    tests =
      with lib;
      genAttrs (map (x: x.version) versions) (
        versionFlavor: azure-static-sites-client.override { inherit versionFlavor; }
      );
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Azure static sites client";
    homepage = "https://github.com/Azure/static-web-apps-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "StaticSitesClient";
    maintainers = with maintainers; [ veehaitch ];
    platforms = [ "x86_64-linux" ];
  };
}
