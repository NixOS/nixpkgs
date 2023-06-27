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

  version = "1.87.2";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.1" = "FEb0NBJpwoYaNdEHEn4TkSQR7VShGpHptaDIRKwrmkQ=";
        "8.2" = "itB0Zm1Mog18F8vIHn9AZMYMzafLQR0v5zcOgqy1ouI=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.1" = "0bX2frll0ne6H6o7HNH4TRV2D+NDe11mVvqwhvSDg9E=";
        "8.2" = "U6zmbEkRr3+9yVwUgQ1+SBNK0zWD92S2KBOHJ1gMmjM=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.1" = "agLQVI3u7ENcWLDRx7YSEBZobRnwEaKAmFpIU5AXhqo=";
        "8.2" = "Y2bUYaymoZ/Ct5a7K+5U+zNh9ZKUaq0Oal/v04nzuaU=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.1" = "ovTtwXPut9jCvxVyd5mQzrfJPCy+rQvUi4c74NrBzY4=";
        "8.2" = "8hybE62l8vSwbqpcrnj/lI2Wjy8R3wuO04zwofLi9EY=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.1" = "WsHH/XJboHeRhxpYY0WtXEJwOsGNFtfexBShC/J7GaQ=";
        "8.2" = "w3Vu7CTFebn59i1FYVCYHiOadTIPlPCkQ1QHEfvHWig=";
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
