{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.92.16";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-HcgIDyz7O3B4PGyNvf87Qw9ddxIyMy4Wt1HunsFDYto=";
        "8.2" = "sha256-JKUAw3WDw99lFF/Rl4Pw2Wm3EpAQLR0awfyjpiEkOcg=";
        "8.3" = "sha256-bXSJbLW3Oz4mgSRyzkbSzqP8YTdilKas+W4HtrX8YTk=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-Eo4teWlzEPw3j/v/5FqFNGykXUZDmWGMLK6LNNkFBRQ=";
        "8.2" = "sha256-hf4lmaJeSBT1f2fJ3qduen8i8Fat+U/u0LXecaca+J8=";
        "8.3" = "sha256-p4+/B11BDJlvh+tFfn3rgE/Mp3vJ5QRV/hVZjn9wAUI=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-LcOjqZ7WUfm7Woa0S4Zs0jEsErd9yfdSj448s3ym6PA=";
        "8.2" = "sha256-ZT2QQqMyezZ0FFgBUECvvYxFWZ8UnDPrQB6zLx0m5hU=";
        "8.3" = "sha256-q8aNtMq/olCms240b0gTyEsTqNYgJWJhdtmzIU0S0jw=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-lzOmGL08eQlIYnHzy7wijPiFYC7bS8Rn/6zDMj6Zhj0=";
        "8.2" = "sha256-PcUZ8elx/wojILwNvH8bF9DxUXBUiSkHzBeD2h2ypGM=";
        "8.3" = "sha256-8z2zYYvoq8adeYm22TQ6iypjwfh/dKzCbXAkoNIBMpY=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-8X3oeEUWdiqurGSreCxe3lmexsBix4KzrWYNWxOfceU=";
        "8.2" = "sha256-iwJs205ZiInw3Rs6TxBF3iw2/t/wxRMXHQpVnxRPPb4=";
        "8.3" = "sha256-fshkfbS7wOmevw8ClqPKneIv+UtXYo4sWTatvS9gOnM=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.src} $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "sha256-${lib.fakeSha256}"
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName = path:
          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams = path:
          let
            # The path will be either [«system» sha256], or [«system» sha256 «phpMajor» «zts»],
            # Let’s skip the sha256.
            rest = builtins.tail (builtins.tail path);
          in
          {
            system =
              builtins.head path;
            phpMajor =
              if builtins.length rest == 0
              then null
              else builtins.head rest;
          };

        createUpdateable = path: _value:
          lib.nameValuePair
            (createName path)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource (createSourceParams path);
            }));

        # Filter out all attributes other than hashes.
        hashesOnly = lib.filterAttrsRecursive (name: _value: name != "system") hashes;
      in
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          (lib.mapAttrsRecursive createUpdateable hashesOnly));
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
