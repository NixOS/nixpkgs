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

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.92.3";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-WyduRLnXWR8B5CPMfQyd9yBSTCb/SY/yH2Me8FSdKsk=";
        "8.2" = "sha256-oQbsQpftQnCzrAqdgkwuz9Igg0vWzYN030ZpkPL9a6Q=";
        "8.3" = "sha256-NVLVi6IRd+kJSkG0/70MFfCyv4qaFr/vI+96/taiBSQ=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-5k3GAB4LoUYv/QS5EVv5xVhv7RfBYq4Tkzr7q/+As7M=";
        "8.2" = "sha256-VK7USg73q8WUQoq5dZ9au8TtbiCi9FUwi8CONEMipfQ=";
        "8.3" = "sha256-TT2lMVtI+Frn1EVzGUCy7MSkPhYOT6hgD4yzv3Bi4Uc=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-t1I9CQ73iK3FM5dhTV68uitwjR+lNZgpWFhQnOkzTWU=";
        "8.2" = "sha256-+GtJVqpK1+CXJl4gxvttcs2fhDoNcvE1Gqd8TNy6IFU=";
        "8.3" = "sha256-KTKu6Nvv5Xdk3PzKzww5ZWYtG7eRgedU2AooYZGLE+0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-q+2xEeHxb1jKz/5o83OuJGXQJ6EFLZ0esUzfe924vio=";
        "8.2" = "sha256-Ug6Y7nqSFGUcm4YvTrYTsxifavmPrsqfomNZceaiHpA=";
        "8.3" = "sha256-6BEK56Naxzk8m7UOV40pFqLTbSd7jsA8VEOPEKZjbzM=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-jE5z02gFUkFCBPg/KNrtRS53TifA3MkuztXQJm2x4qw=";
        "8.2" = "sha256-Ix+qb1jWHdxKAh0Vjpe9O2Yc0I6Qwb+qLK3vNLqpZVY=";
        "8.3" = "sha256-PjUFoZQnk4VRRCQE1OddzxV5LRPa2uQawpYzfooQSk8=";
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
