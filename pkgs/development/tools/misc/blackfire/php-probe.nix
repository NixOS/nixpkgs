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

  version = "1.92.5";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-DT1ETsJGOebC0kt4zKiSMu/wF0TG2zUiNNh+Giokjz4=";
        "8.2" = "sha256-X/inhHAA34aQSycoSzT28jfntH3QTZgHPId5zYgcWT4=";
        "8.3" = "sha256-SHR+J+yFA2YxggdNPq2HtLkh9I3bG01TMk9EUKGkRM0=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-7aDO6shHWIAgby8qCwpc7aICnWyYvferqjDgtnYZCeI=";
        "8.2" = "sha256-mpHS9zUjgJnxvi3np2sUS0GhtOjhDOzlepRByYbjUCk=";
        "8.3" = "sha256-75C9NwMuUTNuAfdPRgtq4XK6bqo/IRa/SXfM7Wz2y90=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-Vj2rnKik+Fy+9yfbUMSOoiXTGm84YNPo1cfh9hojr9c=";
        "8.2" = "sha256-lvWwwKJj3/ZxAQcnbcjv/0CLqDDRiOkFo2rJeMhZLHQ=";
        "8.3" = "sha256-yqa5GE/FBINR3oFNTP1IZGnhSDYCfluRiEFiTSySjns=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-OcQtr16Qt6TsxPBG3OY/viGXqknKx5GdM/fcCJlFiaY=";
        "8.2" = "sha256-ay/6JwB959bT2f18LGMB5560dIPAPSAY5Nby44FGBMc=";
        "8.3" = "sha256-7yyhcusin7pLYZqjUgyIkDGmufIPX8cKWqplXetZzMU=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-l0xgj0tAjYNI0EwoZhnGpRadg5EJtBlt5WhylmZaGDg=";
        "8.2" = "sha256-lD6lE6u9nzHhHPTPLoGKaDsZlvrpbshd+4fr4ua8H8c=";
        "8.3" = "sha256-CMPv+pDPJVwQ4gDAnQxyeJXp4YYkwAVoSdS3a+49fDU=";
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
