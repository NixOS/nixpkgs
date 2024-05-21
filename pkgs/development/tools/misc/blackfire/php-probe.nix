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

  version = "1.92.15";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-CTh3HdTZS5tjnSN5JUX55aioFSqs3FQfy7S5ofXlyBs=";
        "8.2" = "sha256-q/Zwpvm+pT6JdkC2nX7fEf+eDmWmtLniL+5Cys8kdNI=";
        "8.3" = "sha256-8MGY3Spa4cWqUL4S/qHKPJql5DRhtvmYEE3oBLNNm3M=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-mOiBQLXiPYMgHpcPTguEm0hffm+DZnv6MCbFbmRoEdE=";
        "8.2" = "sha256-3xPG33DSxnQ9a9rbTov5ILi3hPWsruNZJS1NXttxfxQ=";
        "8.3" = "sha256-4Nk+8ZIZ83/oeygDdhHI0mRRCvOEMmdWJoteDVkYuT4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-5XUk2v65ceHqnfatLq9E1+J5QRgCDpKxR4ZFpCAsfdI=";
        "8.2" = "sha256-Lr8wBAXYHXwPokwQMni5tsNncor9ZRjNwtL/5hodUq8=";
        "8.3" = "sha256-KZLPFaa5NPksfhA99S8qV3FngJTDonhG+MMPkCwxUys=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-G5wrH9M+b69BLKRI4n9FydGDV/q7Ch7u+Zvol2+ptwI=";
        "8.2" = "sha256-zgcYT2oWCa2kc4wLx94nxRjg0sebjdGxuPJNbiBZ/Is=";
        "8.3" = "sha256-l1zNH47lNpHj7qRgqoxJisn7dU2VzSGFt0v8/9VpYiI=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-mmmzmR4yzwmXAl6YoSOKSivF7uixGZYaFQVIqWd0Ud4=";
        "8.2" = "sha256-1jnw3BADm38C1Hi4lBs5B+kJl1karTljVHxHGEfZmtw=";
        "8.3" = "sha256-7a2JyeLP4HwyaYsb7zAio2HrUPbBVpVEOUjWKCilkFY=";
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
