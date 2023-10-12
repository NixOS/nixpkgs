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

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.90.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-Cq44SJXe8B/RtVGFDDljDBPVs85ELa1K8B7q1u5SEug=";
        "8.2" = "sha256-YZ6rEYfssG8bF40wpEGvW5zb1aoIpo3pM+AEZ7yU74E=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-Gc0kin1z4WLT67lQjfQb1yxZ45bo/q9KV4RQN5zmnTc=";
        "8.2" = "sha256-46OF4GMwHFG1CPQJfHI7OrMYGw2hJXgRIFLKcnaKnaI=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-rV4YoqGOOQWK2WR5RY7SQ/xePpD54vA4+Km8rFNpv4g=";
        "8.2" = "sha256-9NuJfa/n3/tyiSn7lcrOUhD+eYUuanJsrzVAJ9cYWhs=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-G9cep5apYGFEdTOka3QClteCmEUktLtV8I+oIBzsZ9U=";
        "8.2" = "sha256-3wGiekRaGUEHdTpUniPz0Nay2AM0DOQfgFUAC1ezBCs=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-BKdngfG78U0lHa7MTW1kndeM2umyEn7ns5T4mglLWnA=";
        "8.2" = "sha256-02kXdXqj8HuJG0NblkwYPvgiAmbxC19X0xQ7XU2anhg=";
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
