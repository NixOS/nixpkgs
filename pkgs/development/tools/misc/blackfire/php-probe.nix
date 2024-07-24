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

  version = "1.92.19";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-P9KXGnVwhoYWJfp4HShfZ/jEq2U0fZP5tgTmQLRrkrg=";
        "8.2" = "sha256-PBEVpnlLeXDaQkjzUqA4Wlt629Vss9hxPaosDhB7GZQ=";
        "8.3" = "sha256-pJkY31YvDXJo/Ag2BMlEv4HMCsDNjdBFygjAWS9o9cQ=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-bRGW/Iw3Ok9QexWJ0JG9toXr7ml8GHDFGioz5XIfulQ=";
        "8.2" = "sha256-0D2mf8q0dR3fLt2dnSiouVwwTT5wQVtu404CYTHZgQw=";
        "8.3" = "sha256-W2VimZ6pTFUJsA/VWUoeJwdwJS7Mj55HcewG32OacPk=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-c7etUw+FsdIEu2w2nmqmSO6c2f1bGEovhxdvMW/pIh8=";
        "8.2" = "sha256-dfBOE5LiQ/rmK4vCmclTF4LRmS2B2L7aiiim5p4bsoU=";
        "8.3" = "sha256-zeNi17X6QNh9F6WvNmaYWzqD9QJJWRsvmuZuh59d2zA=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-Dntp4EKEU8fTQkl2x0cYlHA1BvqrY2hT29nG9z+AftA=";
        "8.2" = "sha256-V1Dhw5kiU85OTZ50tPeK4clg/ecueJkyaEgBTPy/k0w=";
        "8.3" = "sha256-F3HGLq6+kuuQlXGVkwA/igw3I9IbuvJ1AisMrOuz2Ds=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-7q9b9EAcUIJdyl7ggjDqQ1MF9k+mcdCrsIprL51ep1k=";
        "8.2" = "sha256-9MOR4mHJ9q/L/jQZGrlojJzMlYXeU6VvNsHqnlF6hl0=";
        "8.3" = "sha256-BK1dx9R2VpQM+LxxmkOujdceD3OM7g1LmqoHv3gkd0U=";
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
