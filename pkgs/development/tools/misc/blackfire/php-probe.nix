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

  version = "1.78.1";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = "Q9VuZewJ/KX2ZL77d3YLsE80B0y3RYg/hE2H14s9An4=";
    };
    "i686-linux" = {
      system = "i386";
      sha256 = "YBt6OAeUsQZUyf7P6jIvknq2K0fGWl0xmJkEXFBlTyE=";
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = "NTM3xdu+60EBz7pbRyTvhrvvZWVn4tl+LgnkHG1IpYM=";
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "7.4" = {
          normal = "4raEYMELZjWfC82348l94G9MTHX2jnF+ZvF4AAxN9JA=";
          zts = "HWrcLRZeyFtfJId42iHDN2ci0kTfRoXC/pEv2tObNT8=";
        };
        "8.0" = {
          normal = "kRTULbqlaK3bXRC8WQ1npeZHqWnuobN7eO20oYD5OIE=";
          zts = "vWmSXueMIdi+hwmmhCQcltywphLjsNQoCW7eN2KDRvc=";
        };
        "8.1" = {
          normal = "JSM/HC2ZYaSBl+cSUtaKQBYPziKk013mwyW9S4DoXFA=";
          zts = "9OMm9rEs0o+daxhZdSps4NWQJegLU09zd3SLclGDOns=";
        };
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "7.4" = {
          normal = "rWaf0Vjkrj78q+64Zy7gJ94Lfwd8waMaOWqoPqRJLRw=";
          zts = "zU4cPAWc4k1OEho0fZKutcJ06LstSZhA4U18zx9nfi0=";
        };
        "8.0" = {
          normal = "huGvDPaAmfy8YM6Bg3Y0Ys6JhfIdddOXl1DnnRQsvoE=";
          zts = "V4QWMdMhbjQtb2M7g+oHvqy+Mv0Y9j9MwyqeuMZfYkg=";
        };
        "8.1" = {
          normal = "pnxegrKPe8WoYAcrnBJanoYT1rg8nO8kQ7SJXQJfymg=";
          zts = "m0grZ4Xl6Sm5ZPvmS6mcJGcQOA2ECPJKvzmccqPlyBE=";
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
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
};
in
self
