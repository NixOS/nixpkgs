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

  version = "1.86.4";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      sha256 = {
        "8.0" = "lgFetQ7Z9GeNOjhNvNnCJstdytC5OamoCNl9MFyoVww=";
        "8.1" = "+xbnz3MSBvEV0sST/SGc+wHZe3S7+6HwWL1Gk1wVnJk=";
        "8.2" = "isMrxPfmj6b4RBzurZX6Qpd/K2V+vP3k6myV57UjtvY=";
      };
    };
    "i686-linux" = {
      system = "i386";
      sha256 = {
        "8.0" = "yLxiJqL698ntQl3IVmTb3nEgwmkFMrqFafT8UQfHOLs=";
        "8.1" = "eGSs9IAVhpG4al7qbeqOMSxN4OAkI84D7EidTvDgs/s=";
        "8.2" = "cqYefnX4Q249W5fToX8nCL+BMSRwDBlEXjtxp0mveh4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      sha256 = {
        "8.0" = "etASHFAlcGfR3kgtHfs337XL91QwG5e1GzC7D36JhUM=";
        "8.1" = "dYqP7MjwuJcQNpBSteEV9na0C7pvA4sSHrlQ0NTUDJs=";
        "8.2" = "+501L16rl5vlD7qFGa0o335GWLaIvrvN2nq11gf+W98=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      sha256 = {
        "8.0" = "j2DlfsuQw7y3gxc3JpMxR4d6x7pDYWWCQsA4ilkI8Z4=";
        "8.1" = "Cg3m2VH1NH54TXe9+2FTpzTHQS2ex+43aJ7XGQqka4o=";
        "8.2" = "JxMBqYMHkXMeqKuuum4cmTS+2BFq4OIEFmCCMTdlFoU=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      sha256 = {
        "8.0" = "j1K27FsITfpZzVVDIZJeooNv7iIBL8MTCMJHJCnS9XU=";
        "8.1" = "JzR7fHg4P0H2I4ldZZYhojsDRVpGlPhg7UMrL4WbLyQ=";
        "8.2" = "r48LRQlzMPjH11KH3T05x/nCSDmw6KSiiUt78NcKyOk=";
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
