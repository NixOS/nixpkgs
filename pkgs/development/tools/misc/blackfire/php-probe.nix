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

  version = "1.92.20";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-HAr+bSv7t7jJy5S9bReVF50EWLWzWmoLe4dCNFB0IJ4=";
        "8.2" = "sha256-6twIng5yfLp+4ronaNzXjEVBnHVsd+Sz1ydURMQaRIo=";
        "8.3" = "sha256-X0LzUHId08T1T4RUYSPyHP6pVot53B3tuvYsB3B9X6k=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-YPVMQMuONZNFIGj3A0sSajXFaUj/NsDrH5+DVrOA1Uc=";
        "8.2" = "sha256-ASStFQDrSEbaz+YE01ROBJ5NkRaGok/hYppKGFcEtQM=";
        "8.3" = "sha256-ZOuwpGLV8Taek0XE13jkDG8sf+d+OBNIyOf9POtvpWo=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-PQ+H6EqufUM3GoFUUf42Yj8mLxuDqvz4ml3/khuriag=";
        "8.2" = "sha256-3JeZAst2jwyA7ZzaEl/7WN1D0VqkGCg8UtJTmcwVBEg=";
        "8.3" = "sha256-wQOg1TUG0+Ld3xJ1OvpiKAaFuPe7Vbr+D/G70FSGo4c=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-o9YXtRuEYyp6a03z9v1F0C3KlaQx3Y4q7JIw6vvkPVo=";
        "8.2" = "sha256-7PWqR83ir2h89wuovLOoCup+dkqz+ggXN5HzF0KYGMY=";
        "8.3" = "sha256-SFG/lqD4iR8iDZTFGcu3t6BeFm3ZDtUiPP52trWrEEw=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-n4RIoBpOCfp5lugG6gzkCGRjycbs/JHUqzQAA2D3OU8=";
        "8.2" = "sha256-jNzjOIUZfiXuYIpk4Wtx4C1P05rPgl+8rKqSMj8iD1I=";
        "8.3" = "sha256-rMd/KOwuPRoHZC97OJppiFgUZ2xyBDPzire7y5D+q/Q=";
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
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
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
