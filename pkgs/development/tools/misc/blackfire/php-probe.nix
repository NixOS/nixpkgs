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

  version = "1.92.14";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-a6kPE2HEj92XlgGUSPmil2ply+ypW7QbqPUk4dQR/us=";
        "8.2" = "sha256-/33/RRQzSGMeV41YXmKQFMawHBS6l8ewaQRwiUnrkl4=";
        "8.3" = "sha256-M4vFfucys/DTbAm0xwhC2KZ3HrPQ0r2g8WLNzr+cWmQ=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-w+NRriK0F6DaWUKRF2Irphnw/5RjMZ56XRVTgY1HRqk=";
        "8.2" = "sha256-XJjQ3545cEWkWZGQIS6GAmG6d64uCCEqbTl96iX44Cw=";
        "8.3" = "sha256-2/8duEjnAA1CMfN2HEL2zH7pad9jDZMA6IrTxfMHZv4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-DiNt17csOh3w2ZaQqattdCEbCqR0jAh2E2wm/B9EPtI=";
        "8.2" = "sha256-wGee78wfvbiPxtTdqfYAfvHZxv+dj9dYW5pDPPWgqW4=";
        "8.3" = "sha256-28n/p9gyMoPjuS6ua/UO1Z5FGdVciTrVS7Pyz2D5NVc=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-6SmWgpWGX3BKAMOdTh/CTITUKXiT681MHKgKXlrymv0=";
        "8.2" = "sha256-KHuBiFBPWlERJSfRmum74s9xZf0nT28p0NAJaYv5p7Y=";
        "8.3" = "sha256-ziLv+t+jHo4tEk7gseOOwQzFJKqGxE74XSxizl9LOrk=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-vZLOk9cTeyHxRhvwJFrmzX9EasSfCxVXSZ8aYLysX3s=";
        "8.2" = "sha256-fk2IBiQPqAHQgaymORu/fb8Hl4yzpMeiIU12x8X8WcE=";
        "8.3" = "sha256-2mf21oTvN0LzujAKtlDuFEQgYXny8cJfBXvYBy+kIPk=";
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
