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

  version = "1.92.13";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-QpvnhIvjhm5tqOP72T2yVxV92M3ty/iDICaWsOVFpNg=";
        "8.2" = "sha256-NhNbhOGRlhGvTcG4uZwTASWqLp7PQnfDW48GzROxkII=";
        "8.3" = "sha256-Gn3M0ANj05QoAZB6W3HWj4zNCDya7lqa+OTv57fnEQ8=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-zhCjSPTO/RGcc+qvkYlEeV+9ulIXpA0dCMRlSWwj8ys=";
        "8.2" = "sha256-J+zdMC4q+MHmwADivqdEfSq8h/KeD5TAanCJKZLuEog=";
        "8.3" = "sha256-GGNje7mg1uaLN3zrDXG/igLW9+nhxvPp7nIYW6aJBa4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-C2ie8tp3F0sr+edYbUBVw0b1YJtnjyneC8/+x6LWENg=";
        "8.2" = "sha256-Ku1pulSErVMvBtiNvLgRw2NpE/bEOkjZ5TY7F/PYJto=";
        "8.3" = "sha256-/U/qf7Aqxssvcnc06+K5JeG96Ab09zRvUYcwhSAW4b8=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-OdqG7G3TzuCVzBA0Xf+It05S6XaVlEd+ugM+gk70OiE=";
        "8.2" = "sha256-/nCBQzimhcCrzNuwSVybHBmZZJImm75jKGqh2oXyyZA=";
        "8.3" = "sha256-C2SxPYYXewU6PekQ3m1MBiPMPS5tE53gda2Qo7rZ1YQ=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-W3reCFcN/bM3hrUeekJLG5qntH/Wvfb+JVly5+g2YEY=";
        "8.2" = "sha256-d2YSmyV0mq7KBqoD4Bwdh3izh6hcKTBf6kP+q3QVnfI=";
        "8.3" = "sha256-JiCw8Lew2laxOyb+2aSDqlZz2MafFwYwV46dqceEcBk=";
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
