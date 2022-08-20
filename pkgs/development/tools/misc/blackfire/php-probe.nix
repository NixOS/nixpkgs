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
  soFile = {
    "7.4" = "blackfire-20190902";
    "8.0" = "blackfire-20200930";
    "8.1" = "blackfire-20210902";
  }.${phpMajor} or (throw "Unsupported PHP version.");

  version = "1.77.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = "oC4pANYT2XtF3ju+pT2TCb6iJSlNm6t+Xkawb88xWUo=";
    };
    "i686-linux" = {
      system = "i386";
      sha256 = "zdebak5RWuPqCJ3eReKjtDLnCXtjtVFnSqvqC4U0+RE=";
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = "5J1JcD/ZFxV0FWaySv037x1xjmCdM/zHiBfmRuCidjs=";
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "7.4" = {
          normal = "vKOH+yPDyf8KxX0DoEnrp2HXYfDAxVD708MZrRGMEEk=";
          zts = "cpeOtDRhPA35utai8G1Dosuqhf76hiqvwe+Em9cFhDo=";
        };
        "8.0" = {
          normal = "v6PD1+Ghvtoq1wzAXwqi9elyC9/NwzX0EDdtQtCfeL4=";
          zts = "Dqs0P8X7ScDJCPYKuqlumnLz4kB7cEOnVbDACQ02sko=";
        };
        "8.1" = {
          normal = "mCZ1avC8FsqYdGYNepeqWgSK2kqVo1E0VjhofxdaSyk=";
          zts = "zliaM2VbaDEgNBr5ETe1GdYNyTZy5te92LedZiolx/8=";
        };
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "7.4" = {
          normal = "nLsrpRnR9zo3d/a0+TFBlNcAebknpBQc101ysqPs+dU=";
          zts = "o7R8zmhIOtiNDS8Se3Dog+cn9HyTHzS4jquXdzGQQOU=";
        };
        "8.0" = {
          normal = "Pe2/GNDiS5DuSXCffO0jo5dRl0qkh1RgBVL3JzLwVkQ=";
          zts = "zu7QgaKbBNQkby7bLv+NKLSIa79UXMONEf171EO+uNE=";
        };
        "8.1" = {
          normal = "3SOlLeLCM4crWY6U+/zmtWmNYg2j0HC/3FWCmCi7lOo=";
          zts = "GG8s+Pd0K6SEUzRV96Ba2mYfLgQMuGNzRoUtmz9m0NY=";
        };
      };
    };
  };

  makeSource =
    {
      system,
      phpMajor,
      ztsSupport,
    }:

    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null && ztsSupport != null);
    fetchurl {
      url =
        if isLinux
        then "https://packages.blackfire.io/debian/pool/any/main/b/blackfire-php/blackfire-php_${version}_${hashes.${system}.system}.deb"
        else "https://packages.blackfire.io/homebrew/blackfire-php_${version}-darwin_${hashes.${system}.system}-php${builtins.replaceStrings ["."] [""] phpMajor}${lib.optionalString ztsSupport "-zts"}.tar.gz";
      sha256 =
        if isLinux
        then hashes.${system}.sha256
        else hashes.${system}.sha256.${phpMajor}.${if ztsSupport then "zts" else "normal"};
    };
self = stdenv.mkDerivation rec {
  pname = "php-blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
    inherit (php) ztsSupport;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    dpkg
    autoPatchelfHook
  ];

  setSourceRoot = if stdenv.isDarwin then "sourceRoot=`pwd`" else null;

  unpackPhase = if stdenv.isLinux then ''
    runHook preUnpack
    dpkg-deb -x $src pkg
    sourceRoot=pkg

    runHook postUnpack
  '' else null;

  installPhase = ''
    runHook preInstall

    if ${ lib.boolToString stdenv.isLinux }
    then
        install -D usr/lib/blackfire-php/*/${soFile}${lib.optionalString php.ztsSupport "-zts"}.so $out/lib/php/extensions/blackfire.so
    else
        install -D blackfire.so $out/lib/php/extensions/blackfire.so
    fi

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
            ztsSupport =
              if builtins.length rest == 0
              then null
              else
                builtins.head (builtins.tail rest) == "zts";
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
    maintainers = with maintainers; [ jtojnar shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
};
in
self
