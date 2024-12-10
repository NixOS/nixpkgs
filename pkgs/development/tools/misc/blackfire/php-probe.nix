{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  php,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;
  inherit (stdenv.hostPlatform) system;

  version = "1.92.25";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-owV7Eo/2Qszm5alNppm6DHS7YLZyFDHnQ//jRfM+m1s=";
        "8.2" = "sha256-1eECdIo+eET5tZz9neuC8WRtuJpNbJz+A2i0J9lqnms=";
        "8.3" = "sha256-rfY849xL5AjWNtzzLIud+8+JWuOpmhNM7pdpR1tnNmo=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-b3Dy18FawjtuiASwYCdS1Q5gOv1WSx6f3ESwow8wj4E=";
        "8.2" = "sha256-vFNT/KR1RkxsYwjxLZewSYv2MbG1P7qdcxwzGZho7as=";
        "8.3" = "sha256-TtsWgvrw4orrOFTuWPaPlS3LT9d101HiCGIrBKz4MaI=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-bCS3gfUDr68KKmWy73G9ripYlCTAZuMssThyEDCGDgM=";
        "8.2" = "sha256-FQlfdsVeClSLLCJqQPp0fo1CqpshkTo1iUw/9QI9JBc=";
        "8.3" = "sha256-cThRmDf1HTaCT/KuvT3TMcmsCMky407p9u3hwtGtWDQ=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-ZbUUtljjvQ0dcly/eTovTECTZn9OOcx3VDe1gKEICyA=";
        "8.2" = "sha256-8xjs5IrsdbcjmTfni/hbtN+qFmnUgFK3KG8ntbNgBeI=";
        "8.3" = "sha256-kDf+5rATt6/DMH5zZoom2Y5j/6CFFj8claJHlMq285o=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-i1QxRGump5G3eMKjXFokqRr9FD6wsdPoUbjE7w3/a0A=";
        "8.2" = "sha256-O7L4LgAbLRsz/F+esGwwnxAdD1gT30QEy3FEOQxTNu0=";
        "8.3" = "sha256-a5oCtzCb8T/bA5GOOfyN7dMzeK29ZUBZceEnlqme41I=";
      };
    };
  };

  makeSource =
    { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${
        if isLinux then "linux" else "darwin"
      }_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in

assert lib.assertMsg (
  hashes ? ${system}.hash.${phpMajor}
) "blackfire does not support PHP version ${phpMajor} on ${system}.";

stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    inherit system phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName =
          { phpMajor, system }: "php${builtins.replaceStrings [ "." ] [ "" ] phpMajor}_${system}";

        createUpdateable =
          sourceParams:
          lib.nameValuePair (createName sourceParams) (
            finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource sourceParams;
            })
          );
      in
      lib.concatMapAttrs (
        system:
        { hash, ... }:

        lib.mapAttrs' (phpMajor: _hash: createUpdateable { inherit phpMajor system; }) hash
      ) hashes;
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
