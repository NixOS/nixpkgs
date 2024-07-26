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

  version = "1.92.10";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-U2vcgqnpz1+pS4aE3usj/ktrbnXw70+xpedx1LkbTvI=";
        "8.2" = "sha256-rX57nPA6Fduzv5t/lGYnIPXSbW8ddlpQrDDqj3CUzQ0=";
        "8.3" = "sha256-DXlMHZvGZMdzVRVe7Mv80sGHwUkWcr99hsWl7VnOrb0=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-Czua15eOomeIwaVll6THoKWlg2KSoj8TZn/kmpik8no=";
        "8.2" = "sha256-oFqbLJUD8IlhdM3qT1zZUqPs/eikDJB7UqEc5RdPWGk=";
        "8.3" = "sha256-/ueCOSPGdLDUQpaPOkiOkk1+xKYAFQoRPVUjrbGjkgI=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-F3bxCPvlXnBNXcp1ia47HdEfrronRqftTUQkvV2yeew=";
        "8.2" = "sha256-dLUfo13RILacTgHhfLvzFOz8OvwO+Nv6L6hQ7XE2o5c=";
        "8.3" = "sha256-NO6n3euYq0Ind6oxLaSRmj6FkmeWJme+ZcIfumQtEgE=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-DNkRaUD+/MsK8K1i48LnekooKjYen/SRMcYNgVTxRfU=";
        "8.2" = "sha256-4MwsaqFozn6ybkjDIj+FUQv42I5YyV7gKXyTmNuLdRg=";
        "8.3" = "sha256-KZR0oO53S1cdao6JQJKsNGIUk7bqR1xYcJeXUL7RW6g=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-6rglM9HYhNdN4kumAOQibYt95oa5imgnfkhYDuC3Iso=";
        "8.2" = "sha256-+Mi+xWdWYFwrKPL9szo4C0jZn+FMPSmdKiVAiH9MxtY=";
        "8.3" = "sha256-0CwhF/z0phPYuOSZ0PRTG90DjjXKFKFEtAovCHYtRFw=";
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
