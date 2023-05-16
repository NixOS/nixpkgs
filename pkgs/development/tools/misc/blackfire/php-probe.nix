{ stdenv
, lib
, fetchurl
<<<<<<< HEAD
=======
, dpkg
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

let
  phpMajor = lib.versions.majorMinor php.version;

<<<<<<< HEAD
  version = "1.89.0";
=======
  version = "1.86.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
<<<<<<< HEAD
      hash = {
        "8.1" = "sha256-hRxg33h78MssWo5CuOxN7X0oPxFU6RMkncs751N1lWg=";
        "8.2" = "sha256-uAat8nfTnYiLfAzn0CRrYwrtXQgHYjZIaSnGI8CNSzI=";
=======
      sha256 = {
        "8.0" = "zoT9f906lvMTyq+w7BAqwA3Wnadk0hEsc9KLYuffE8c=";
        "8.1" = "KJB3/BlS8FCDg3CEaYf14RJk3xhda1K2XEPVylSRFTQ=";
        "8.2" = "PrhPtYUkz+Zs4ctIJUsHlUqLHZDfXNMc7s6uA5RJNVI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    "i686-linux" = {
      system = "i386";
<<<<<<< HEAD
      hash = {
        "8.1" = "sha256-DpCfuq4RpI8078Kq8YJYNONpZT2k85jVIjoiFU2Mj64=";
        "8.2" = "sha256-IWkxjy2GBaFUeIJULRsrLrskh5CNW2DDTK5FJKGRuFM=";
=======
      sha256 = {
        "8.0" = "IByOPOvzJZOR9hw6Ngn81XtXBczRPLswDA4Mvh8dQdQ=";
        "8.1" = "Mob30xhKWaREiqw3cjlrz0jtAc9onERT6NxTz9bUSSY=";
        "8.2" = "a7paFrgLfMLvcQRcHPi+sJ61XTjphcba+tewrJw0OnE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    "aarch64-linux" = {
      system = "arm64";
<<<<<<< HEAD
      hash = {
        "8.1" = "sha256-cTIbsHHJvKIFgXTlH5jog1uoaUVD4ZkPLj78xtEXqVs=";
        "8.2" = "sha256-IDtVd1aE4rUSLKJRHfdbSB0DUm7rCziTG0jmsmMxaGc=";
=======
      sha256 = {
        "8.0" = "6ZhFRjjj/y3yyH2PXVnw+Mhkm2trfpysxfXocH5nx48=";
        "8.1" = "x2TGaehSJmgJJcapr6xBO9Svo1HE66eVRHt/Ab+RSzQ=";
        "8.2" = "YUs8h/DBwaNvmYA9TS7l0skg+X4yBzcHbPH4QXeSdCI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
<<<<<<< HEAD
      hash = {
        "8.1" = "sha256-HzLdzqoXkN/D+Dh8RnKiMcV56yaO3IHH5EVbaj4QFpI=";
        "8.2" = "sha256-9Agz1s1/576gz7bRPzCPmox09K16KOR1Ah0eozN6itc=";
=======
      sha256 = {
        "8.0" = "HZV7I8HOWvGwV9kMuSBW1/vgs+plxYLvbVs/d8aNNfE=";
        "8.1" = "PsHDB/P/vbdpqbLl12UqelHfvHHt2WxiWEUCV7s5ZJg=";
        "8.2" = "pEkFLhjWOLquBcxE06Gv7HUB/lPU8cPajhsFc0kcKlA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
<<<<<<< HEAD
      hash = {
        "8.1" = "sha256-GB+IVCISDAtnXSHNXfxXa7eQcx+dRMiP3LC0haha6bI=";
        "8.2" = "sha256-8EpMJ6kTNw5LDS18zSPUj0r1MsUsAoMPuo4Yn6sWbg8=";
=======
      sha256 = {
        "8.0" = "VOi901nkVNjHSk02HNk6/z9q3avs+doHWL+Zxxruc6k=";
        "8.1" = "TVV9Iysueo1M2WaaX6CF52WzMfJJ96gOIxuy1mIA6ao=";
        "8.2" = "XOcjZes3JNfulJimdCTkipiRzrJ/237SSfqNAelVPNU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

<<<<<<< HEAD
  makeSource = { system, phpMajor }:
=======
  makeSource =
    {
      system,
      phpMajor,
    }:

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    fetchurl {
<<<<<<< HEAD
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in
stdenv.mkDerivation (finalAttrs: {
=======
      url =
        "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      sha256 = hashes.${system}.sha256.${phpMajor};
    };
self = stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
<<<<<<< HEAD
=======
    inherit (php);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

<<<<<<< HEAD
  sourceRoot = ".";
=======
  setSourceRoot = "sourceRoot=`pwd`";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -D ${finalAttrs.src} $out/lib/php/extensions/blackfire.so
=======
    install -D ${src} $out/lib/php/extensions/blackfire.so
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  passthru = {
<<<<<<< HEAD
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
=======
    updateScript = writeShellScript "update-${pname}" ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

<<<<<<< HEAD
      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "sha256-${lib.fakeSha256}"
=======
      for source in ${lib.concatStringsSep " " (builtins.attrNames passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "${lib.fakeSha256}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
<<<<<<< HEAD
        createName = path:
          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams = path:
=======
        createName =
          path:

          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams =
          path:

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          let
            # The path will be either [«system» sha256], or [«system» sha256 «phpMajor» «zts»],
            # Let’s skip the sha256.
            rest = builtins.tail (builtins.tail path);
<<<<<<< HEAD
          in
          {
=======
          in {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            system =
              builtins.head path;
            phpMajor =
              if builtins.length rest == 0
              then null
              else builtins.head rest;
          };

<<<<<<< HEAD
        createUpdateable = path: _value:
          lib.nameValuePair
            (createName path)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource (createSourceParams path);
            }));

        # Filter out all attributes other than hashes.
        hashesOnly = lib.filterAttrsRecursive (name: _value: name != "system") hashes;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      in
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          (lib.mapAttrsRecursive createUpdateable hashesOnly));
  };

<<<<<<< HEAD
  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
