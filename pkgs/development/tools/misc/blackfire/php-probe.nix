{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.92.8";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-zN39X2hd++Z5cj9JN3Athiq9j12i7/Q5QCnohw8PVDk=";
        "8.2" = "sha256-ZgzegspY+aXQDLfRvDBDm+FtY4VzM/OWJG0ZSr4OAag=";
        "8.3" = "sha256-o0ARDtcn5m6z+Ll+QT1JOR1jH2wJNNz1URV9BePViTU=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-8Qr1H9lgf8FxBLPTbxueSqi1S5y3HC3kzRQupfQkTew=";
        "8.2" = "sha256-exrpoA74Ikr3YWcUIB8ZTCkKnJ7YeK4yZ6oDfpcQ3Sg=";
        "8.3" = "sha256-7JirGgtQj8+mtyhEJOiM480bQ+98tv59r4LbMX6/X9Q=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-ubNi2WxOuZ10OZhVzroIjfpBxg1gC1s9Nddj+U4fx5M=";
        "8.2" = "sha256-iUTCgJxmMtuNiT6+TqCqgKIVXF0THQgycxLiDUYdaeo=";
        "8.3" = "sha256-EwVe/hlengd+87w9xpA+pWGu8iXQh5Ldr4tZVgGps2M=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-bSPOUxQpTIsC2pZ95kLvrWJVVUb1bf51ety26miyxy8=";
        "8.2" = "sha256-lncGFHCENSoVMGvKgsE5yBhThsfZ2xdIVDoVgECDV+w=";
        "8.3" = "sha256-6hVAlaN48OLrGEsoqBo+JdNV+NxWpmLwAdv9ymaWkHY=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-aRLxX2FULffZHUNYyrpypLN+XINC+NTaRMIulh61M1o=";
        "8.2" = "sha256-Ma9EgcoM4x3iK8ygcEte/Wtip+/Z4Prs2CvITxGoaLM=";
        "8.3" = "sha256-6vPcc5ogaQs7Z/o4jMR0VX2r5Mq1vpxdf0hvMrQGxZE=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
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
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "sha256-${lib.fakeSha256}"
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName = path:
          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams = path:
          let
            # The path will be either [«system» sha256], or [«system» sha256 «phpMajor» «zts»],
            # Let’s skip the sha256.
            rest = builtins.tail (builtins.tail path);
          in
          {
            system =
              builtins.head path;
            phpMajor =
              if builtins.length rest == 0
              then null
              else builtins.head rest;
          };

        createUpdateable = path: _value:
          lib.nameValuePair
            (createName path)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource (createSourceParams path);
            }));

        # Filter out all attributes other than hashes.
        hashesOnly = lib.filterAttrsRecursive (name: _value: name != "system") hashes;
      in
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          (lib.mapAttrsRecursive createUpdateable hashesOnly));
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
