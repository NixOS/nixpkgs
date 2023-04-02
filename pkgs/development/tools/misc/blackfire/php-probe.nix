{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.86.5";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.0" = "N+SRigtolwNjxdH5/jWazPq7oBh2dxoT6tNBugyVdL0=";
        "8.1" = "MCxZcIduGTbGJsUR16wwUlxc1CbeSAIvNTfI76WQUrs=";
        "8.2" = "OoQt4zAPUQTPCLnNxnc0/e0osjo0eDP7I6sn2n90ZgQ=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.0" = "Vv/rqRvt9ganet4z84rN2uJ6LCvn8rop9jFQdlnYMB8=";
        "8.1" = "lFRY2yWOuWY4Zu3Y7FYbvTSmpZl4epgPKzHffncwXpk=";
        "8.2" = "VSRaPib7RfA5W0FG3JgaXTlGTnOLKaw3tz8p/Mkmpx8=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.0" = "XvLZrfYbyiAV0q/S3ANcafyLGQWkcJuRa1RUWSpaNH8=";
        "8.1" = "msezMA7yhC16ATxN7c4xDdy6PrZ7HVito4x1L3mzh70=";
        "8.2" = "Q7LTst4OBPrQ91vI/V9eN9MHo0qxTD1ZCWMFeYXT21s=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.0" = "OSnjO2nmcqy+vytRNWFYMi8Y20n7AwAwmhDBS7K5MBQ=";
        "8.1" = "VyPY1Gj6q4PpXDLPS9ARt9LUmYIG3hsGlEJjh9944Hc=";
        "8.2" = "M+8Lwx2nzlxLEP+F1vcjB9HgInsz5vOc3AIEzQHrC2I=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.0" = "1xRcZic2XQLFkBhh2H9ZgCpG+1xq4oqhef7qEjhSeLQ=";
        "8.1" = "MmI3TjvmLymRxo/Iy9s49A6le+pZiiflGq+CfU/xmW0=";
        "8.2" = "n0Cy59tVUO70oTidB9lIPUXMkQ8ndzYHtYfXuQYQ2Mc=";
      };
    };
  };

  makeSource =
    {
      system,
      phpMajor,
    }:

    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    fetchurl {
      url =
        "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      sha256 = hashes.${system}.sha256.${phpMajor};
    };
self = stdenv.mkDerivation rec {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
    inherit (php);
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  setSourceRoot = "sourceRoot=`pwd`";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D ${src} $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${pname}" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "${lib.fakeSha256}"
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName =
          path:

          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams =
          path:

          let
            # The path will be either [«system» sha256], or [«system» sha256 «phpMajor» «zts»],
            # Let’s skip the sha256.
            rest = builtins.tail (builtins.tail path);
          in {
            system =
              builtins.head path;
            phpMajor =
              if builtins.length rest == 0
              then null
              else builtins.head rest;
          };

          createUpdateable =
            path:
            _value:

            lib.nameValuePair
              (createName path)
              (self.overrideAttrs (attrs: {
                src = makeSource (createSourceParams path);
              }));

          hashesOnly =
            # Filter out all attributes other than hashes.
            lib.filterAttrsRecursive (name: _value: name != "system") hashes;
      in
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          (lib.mapAttrsRecursive createUpdateable hashesOnly));
  };

  meta = with lib; {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
};
in
self
