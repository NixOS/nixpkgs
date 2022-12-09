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

  version = "1.84.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = "4tAqe1ev2s4ZwzPptgXuVL4ZXF37ieGyonBxOFMUKTs=";
    };
    "i686-linux" = {
      system = "i386";
      sha256 = "OPvn1zcBJDfUu7m3evRayVZNuZJ/KLblm6u4P0z0CvU=";
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = "5P6tVYshPsR4Xl8sCYFuNIRf8LvE6PxWpynP3ZzoP0s=";
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "7.4" = {
          normal = "wNv5LiCbkiyPQFH1jr4Aw4kjHnpqxPa427H4nzNkE8A=";
          zts = "FmvzFtukFZPqOz6wkFEtXrb+H8A9bb6ZqeEN9jjtwOQ=";
        };
        "8.0" = {
          normal = "tEGMtQf/K5x+dTEd067nhalezmWLKf1A4hM7HM1iwNE=";
          zts = "ivbcoqM2U4Zh86+AAml8bHQEn1731A9XsCqW8ai6oKg=";
        };
        "8.1" = {
          normal = "9GFqlGS2qZWSUoOyYb86RyFdUx2AkQlcq6N2cWHFQ2s=";
          zts = "KnxJUxenPxPw0Mo6GdtyLpPN06/K0cSHk2cf7Akf3BE=";
        };
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "7.4" = {
          normal = "s6aS3INNzOMIV0qW5ROrjX68obnixsOZ4ktnDb/3dGo=";
          zts = "4OdHSLLMo9tSVQnaTYfzogeloYPvHxbHhQgACo2V7zA=";
        };
        "8.0" = {
          normal = "JZ6ITbzW7nHmJEQv2KXKPjU9wkY7mH6+tFRJFhJw7ug=";
          zts = "x/uP64Ec2tvUylmnWfxsqJMUNlVsFnrxK3CWHdXfgus=";
        };
        "8.1" = {
          normal = "foK+vRwM6PHgToYiPVZIXde18jYJ3bV0Gz23bNS1UYg=";
          zts = "LhaaUhOSnAPqHn7LqPgq2UOkS/MoY3CHcpGoFeh+hyo=";
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
  extensionName = "blackfire";
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
