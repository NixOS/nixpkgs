{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  php,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;
  inherit (stdenv.hostPlatform) system;

  version = "1.92.30";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-jUMiUtmv+6uwo2t1qiKnCb0WUyelULd5E4Lbjcp1M0Y=";
        "8.2" = "sha256-ZITGC0065QoFEwYEmKDyZmCBOmxhZnUoWbYSBuQnf0E=";
        "8.3" = "sha256-3GlAYpY8KeOHzdv+WbE6VPIvKgEDmqQfCt1Txe160tI=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-uRaaN2pFFRvMyTfWH4kmzoItvdsK2F/elH+24E9PJl4=";
        "8.2" = "sha256-bhK42K4ud9gwTGcepgmOAnHuqdhnFl5BVAVhnBO/7gE=";
        "8.3" = "sha256-8/CymHXqfcC5ewZjvNOIaZelcq4YfLX5M+EJZkWpJFA=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-s/cLlOptINpFsiZxVdgupRhZC8qE+pASNLssJ0w032Q=";
        "8.2" = "sha256-v+NBLaEMD22CX7DuhxqcWA0gaWsg51qhY8AorTzOV30=";
        "8.3" = "sha256-9FZHvOuP5dgymgE1O12X7dH4Mk5TIm7nfK8+/lqET1k=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-oee6g+jpMT79xROeJngpSTk7jId4WMlrGpu4glCUu+I=";
        "8.2" = "sha256-4oeYCScZK/x+GzcF3cqwuIxVJ/CZfVgD1RHdIlpB4B0=";
        "8.3" = "sha256-BOQuR/uqiRtCVtq/OTiEWb1w7wJF1ikrjwEyOXnu6B0=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-tXfzioFSOlM65ZT5lxmr2xK/RipDjTR9pQdOZfDdgCU=";
        "8.2" = "sha256-4iz9HQMjDoybwQJiDkdtt/MCQ3OeIz3x9rh9RZo1Zug=";
        "8.3" = "sha256-ZLlRxfnDA9/AZmLH5kNofG/s3nlxj0rfh2oUgUG9Dyc=";
      };
    };
  };

  makeSource =
    { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${
        if isLinux then "linux" else "darwin"
      }_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in

assert lib.assertMsg (
  hashes ? ${system}.hash.${phpMajor}
) "blackfire does not support PHP version ${phpMajor} on ${system}.";

stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    inherit system phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.src} $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName =
          { phpMajor, system }: "php${builtins.replaceStrings [ "." ] [ "" ] phpMajor}_${system}";

        createUpdateable =
          sourceParams:
          lib.nameValuePair (createName sourceParams) (
            finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource sourceParams;
            })
          );
      in
      lib.concatMapAttrs (
        system:
        { hash, ... }:

        lib.mapAttrs' (phpMajor: _hash: createUpdateable { inherit phpMajor system; }) hash
      ) hashes;
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
