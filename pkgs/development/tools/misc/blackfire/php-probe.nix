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

  version = "1.86.3";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.0" = "Vl16ssG+47CvGNTQBR6aNkEzoSor7B8F71TSN3x2bm0=";
        "8.1" = "27yLfDJYTQ3Izr8M6XFEsEWb7WDmuKjKCdSCPfL9HUw=";
        "8.2" = "tnxlB+Tq8qeRoHjBNl/CMI0UZb02ayssiRJSMZaTwWI=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.0" = "NF5R470FC/nrAvk57Y3wStT4EQrWCvntniD9rD1Fv/Y=";
        "8.1" = "aAl+oX0QfL6wStUrrhB44JHqAvA4ZLbc3dQyRHJbcNU=";
        "8.2" = "SWAC9XlJs1vNWnDWeuXHPOMQoA5kCqiSrWxNpRcXHns=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.0" = "jrTCMkJWzPzzJU7eET+VCwKaiRPqcQKPPIJZrLAuJ6s=";
        "8.1" = "WjomQa3+27mW8tR5u++LyVDtyNa7Bj8uS3FHsmdsafo=";
        "8.2" = "3SGtZkKosxKsJ/qTlP7BFpnroOTRaWFsvDHq1fK1UBE=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.0" = "MDPgDfIOfjr/VMGrxj7159xJl6P3jPYgoNOkISZBmX4=";
        "8.1" = "zV5gjpA9tNGo/p/Is8n8WfGyIdb/IQDbfH1KuD8S4s8=";
        "8.2" = "+zwX3r9X/avQvcmNtt5RT3smY+4yfXFo8XPCiV9xWT4=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.0" = "wEsbQrowYgOlbWUkv+yPtPliC9b/iIUXBsvrCXCL6aM=";
        "8.1" = "zl7OX3LlBLxn0oLYlNbVavxL4rho4LS3EZmAB2x6zZs=";
        "8.2" = "fYGIDxNeBx+HyPx9lhfNZgKUeMJwZ4KvUcJ4jtwH5nQ=";
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
