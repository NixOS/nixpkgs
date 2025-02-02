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

  version = "1.92.32";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-oRd6PbBLOboH9EVRfZl5u71ZoVMFO4K/uftxlL/vm18=";
        "8.2" = "sha256-95qBidNHIGLGCb3QbUIzBMHsRi2GTPhwAjJg+JTteDk=";
        "8.3" = "sha256-8TO28o4YYFK1r2tInjXKenki/izHzZL0Dblaippekl8=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-mXJ1hO8NcODG7Wj3lQ+5lkSjcbkKLN5OOzcobigScKI=";
        "8.2" = "sha256-P5fQTVfE/DvLD4E3kUPE+eeOM9YVNNixgWVRq3Ca5M4=";
        "8.3" = "sha256-rMUv2EUlepBahMaEvs60i7RFTmaBe4P4qB1hcARqP9Y=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-Tj7LHXS4m9hF9gY/9vfOQPJVP+vHM1h8XdBY9vyRhFo=";
        "8.2" = "sha256-6kfotMptfVLPL414mr6LeJZ3ODnjepYQYnKvg4fHIAg=";
        "8.3" = "sha256-M/GTdinOi3Em7GJOm1iUKkuDNg8La3iQpG+wGHp0ycE=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-TZ6D8sTlLuM+8707ncECPNQlpySc7BYKIwSEth3MUT8=";
        "8.2" = "sha256-4VJBo1TzEkstKo2ed9bxb/3g0JFjHlfTIfmDq2dCfUk=";
        "8.3" = "sha256-gIIoRRNCed5cgbcFxvwXKgWZs4HgoOMCx6k0urVPxbs=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-tO52c8FKZXXgx7+0IGiwy5rPLEsU/5ji/c79wzb1S34=";
        "8.2" = "sha256-eUkM5KzZLPK2hCnFqRN8eOwLiX54qXuLkdfxJdjuZTk=";
        "8.3" = "sha256-CaRs3DI5TTHNSk91pqFaHt1OVQzGozATOUs7GNi8cqY=";
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
