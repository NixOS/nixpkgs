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

  version = "1.86.8";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.0" = "zoT9f906lvMTyq+w7BAqwA3Wnadk0hEsc9KLYuffE8c=";
        "8.1" = "KJB3/BlS8FCDg3CEaYf14RJk3xhda1K2XEPVylSRFTQ=";
        "8.2" = "PrhPtYUkz+Zs4ctIJUsHlUqLHZDfXNMc7s6uA5RJNVI=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.0" = "IByOPOvzJZOR9hw6Ngn81XtXBczRPLswDA4Mvh8dQdQ=";
        "8.1" = "Mob30xhKWaREiqw3cjlrz0jtAc9onERT6NxTz9bUSSY=";
        "8.2" = "a7paFrgLfMLvcQRcHPi+sJ61XTjphcba+tewrJw0OnE=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.0" = "6ZhFRjjj/y3yyH2PXVnw+Mhkm2trfpysxfXocH5nx48=";
        "8.1" = "x2TGaehSJmgJJcapr6xBO9Svo1HE66eVRHt/Ab+RSzQ=";
        "8.2" = "YUs8h/DBwaNvmYA9TS7l0skg+X4yBzcHbPH4QXeSdCI=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.0" = "HZV7I8HOWvGwV9kMuSBW1/vgs+plxYLvbVs/d8aNNfE=";
        "8.1" = "PsHDB/P/vbdpqbLl12UqelHfvHHt2WxiWEUCV7s5ZJg=";
        "8.2" = "pEkFLhjWOLquBcxE06Gv7HUB/lPU8cPajhsFc0kcKlA=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.0" = "VOi901nkVNjHSk02HNk6/z9q3avs+doHWL+Zxxruc6k=";
        "8.1" = "TVV9Iysueo1M2WaaX6CF52WzMfJJ96gOIxuy1mIA6ao=";
        "8.2" = "XOcjZes3JNfulJimdCTkipiRzrJ/237SSfqNAelVPNU=";
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
