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

  version = "1.78.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = "67LeltpIDo4Izu1us8Hy0QIkuApJY9IMWWYfNEMNU1Y=";
    };
    "i686-linux" = {
      system = "i386";
      sha256 = "1B65ENoUeCQIPO60wbOZYA3iCOHdae5VHCPQZjOUUzE=";
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = "VEo86VFMgow8/pTu02st4LRn4BqI+RCTfGjOwmM0XgU=";
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "7.4" = {
          normal = "fDECyGE8JVpE1SEuolk58rmx4Qk0kfvSegC9OGXCG6I=";
          zts = "foDJbd69EMXGpzb078jSnVR22AderNp+5LjJYZ8J8Bg=";
        };
        "8.0" = {
          normal = "0Kl+i9VRZ1UlClfdKF3LE381+SJGSwlUD9uv3S0kQBk=";
          zts = "bg7OD2m53wFGIFwwzis4QHhwdXDUvqayH/bGjtBRORM=";
        };
        "8.1" = {
          normal = "cNI3u1qDHtJOfppDH6VUh02mmZq35krH0HCsidxqEfs=";
          zts = "qMfTxxQJ8WgZAy20mevxSVJv6fuSwcmHGBzyNmTezs4=";
        };
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "7.4" = {
          normal = "EtTQf6iHnfNsZqWcuXqd3qVBp3IRlSOqjcry0EX/b6A=";
          zts = "RCTkRG5Iz/tj/ftRpxU/zM3b0kZoYNBC39xr7BY1sqQ=";
        };
        "8.0" = {
          normal = "omS7QJrm3QzGJnguCpZWimORw6hIEJUGk6Hb8OIjhRQ=";
          zts = "eKutEbe65NTx3xaBfs1fYcifaw7NwfWyxJ4jB6uN/+k=";
        };
        "8.1" = {
          normal = "mlqygQMQkf/mC7xmdHDS8lWEkegcvpdwFVKz6oGAxD4=";
          zts = "mg5CK3CQ/EsI+Z0aVRsoO0axM9BTRum3l/VVO7XNfpA=";
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
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
};
in
self
