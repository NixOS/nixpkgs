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
  inherit (stdenv.hostPlatform) system;

  version = "1.92.22";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-MWAKoshKC+hW8ldRLfYQIcMwpSHvW+hV9dRMvZ4rqcU=";
        "8.2" = "sha256-xAdECbxuaV5PxG+X7+o2p5pOEG9lgRLuOTp46k5I4RM=";
        "8.3" = "sha256-4vCLpSy4kJ4qwOSonSFvlevCfNMxjIU6AUswm0uG59o=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-fvXv3Yn3FXBO4EIgb/5LI3jJxV5HA2Q2JCNy14bA8eU=";
        "8.2" = "sha256-0m2ze1e09IUGjTpxbyTOchQBBMa86cpiMrAImiXrAZ0=";
        "8.3" = "sha256-nhVP4/Ls71MxPN6Ko1bDG8PSHkHQt+vC08EbP0WAL8g=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-pvzKVvtpBh+nwppqSqxSsR989mWzwyAHtwIdDjWx08o=";
        "8.2" = "sha256-O6RhO/PY2C4GubYl/jcTzpWeiUKSGy8Np4/KrlMsE1Y=";
        "8.3" = "sha256-3sfjwXq980oRV8u+IAamyYKDp2UMREFaynigz/dpyXE=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-peZmwxzQ2NCKkq5qSraIb4pnnJDwcRkCyGW8qeBSGRk=";
        "8.2" = "sha256-MvF7S+VITEnsJSLz3xEy927zIR6TN+p3nRGQFjKqtu8=";
        "8.3" = "sha256-sUlD8cPk7emJPtz4en6AcFxs/7NUjxUMkqf/Qs3INIA=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-kMftb/fC9uyMZyjP4jmtYLM+xEhFqP7umQ5FLvR9vAo=";
        "8.2" = "sha256-W8LXYz8KzWlzdpyqmo7XQmkzuyfXO0BZSkiBIlfi18g=";
        "8.3" = "sha256-a/Q7avEJr/we5GF2NxTZywpsal5AkAGxEABMPCgy2LM=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in

assert lib.assertMsg (hashes ? ${system}.hash.${phpMajor}) "blackfire does not support PHP version ${phpMajor} on ${system}.";

stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    inherit system phpMajor;
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
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName = { phpMajor, system }:
          "php${builtins.replaceStrings [ "." ] [ "" ] phpMajor}_${system}";

        createUpdateable = sourceParams:
          lib.nameValuePair
            (createName sourceParams)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource sourceParams;
            }));
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
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
