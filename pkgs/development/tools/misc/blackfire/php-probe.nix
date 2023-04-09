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

  version = "1.86.6";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.0" = "DbaawNIl1ZbSaITFUZE0GC0RgrJrjn0Wlb+o3OMhsAc=";
        "8.1" = "VM7RljXwdGgF2ZVvsJ00YIGVfM5JqdRNrALSw+pMJks=";
        "8.2" = "hrFNkAX4Am+78xxFfoSWn+bUZIklhb5uKRo1rGWumOA=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.0" = "FdM+HsVytE5XdjlXDV6mrdylLDQdzCYjxkFrqWwTMbI=";
        "8.1" = "Z6RZShh/Gcu9qLcj/yKJu7qy0RnA+nNFwz1IXCEZlKg=";
        "8.2" = "mytoRBpSCR4Gibpi7AptgbTq+axBXlpfag9LAnVzUM4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.0" = "6sl3RXgBfXlJpmUDRGCmpLRKSmf1dy0vbRVHFnl7TyI=";
        "8.1" = "hDv6G2L+fJylaqmOle0ND9iO28BA2ZPDfDlIhL2gqBQ=";
        "8.2" = "ASm65Jwsc2x6R0sfWHyDWTw/FTeQap+SckG4Jdg2Zn8=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.0" = "zEAd+8v7j1mFOIMc2dThOY7e1XKHyMOx9dYWnJlJWAE=";
        "8.1" = "ZaGwlLcBUSwGoAypw42rIkeXaeVegh05xwVMXfaAtgg=";
        "8.2" = "gz8eKNLHlje3gUiXSIyE2csnOq9blS3GWZscTZbA9W4=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.0" = "yUcxwya/oTmu0acbuhe2ft2pyKroeWHQMouE2ch94EM=";
        "8.1" = "u14WbwGRsDDhd6oZsvGKOgXpTQw3KMVeV1i9wl/vI+I=";
        "8.2" = "oYYgo2qSkCuwNjUrJdhFziWyyWfwm1g+ZyqhudDuuoA=";
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
