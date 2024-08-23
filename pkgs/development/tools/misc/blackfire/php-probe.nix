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
  inherit (stdenv.hostPlatform) system;

  version = "1.92.23";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-/aWW1QY2NVsoMLTv1HOxx+ujhkCx4i+FWcwt9zdfPKI=";
        "8.2" = "sha256-VYHxvpFxLBCDHwWQH0HO+3CEiN4zcry7jLn/3KzvENU=";
        "8.3" = "sha256-vDJCDCF/COlmqdZVinIK9FUXTS5BiDpjUchabjrlpnA=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-CsxaRbLg9j3djLPMbbsrduLXQTp4KJuWPecHWBMWIcA=";
        "8.2" = "sha256-oy1FQ+1wSORHOUidQ8fNEXHMX5bLhLYyZ8mQLzKJh+0=";
        "8.3" = "sha256-TnEYofVT6vsO3AnpsDvwiqz0LeuFkLGS1befnlSFfT4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-znvHYCaI08KWVwht83+fv74IY8hotXnww8eJLj/+5us=";
        "8.2" = "sha256-Da9/wqFLnSE8GUzB4NrqbIAJ81deTgCpAGOgecIX40A=";
        "8.3" = "sha256-Pii1cVwceg+BIbtQ1PhfuqAc60R3gt2o2iel7Zxs7l0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-y40O5YGZJxzZtF03h6cdxvXkWO51bJmykUTlnDZlhzI=";
        "8.2" = "sha256-CRy/G84NFguOZhCDwYWtj3r0rjJarBXvWxS+QkHKzoA=";
        "8.3" = "sha256-vr05O/MtS6UeD078aUZusmORutTysO711f2+H7gcaMU=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-f4YZEfNDC3PM4vUcLJaUj5kRG/dVjIl5+QyBXBIOYps=";
        "8.2" = "sha256-QpfucP0u8+OTPqcB9lrYjg7L7qpLFtyA6Jo+00havRA=";
        "8.3" = "sha256-PBxklii6kseqOcGum/bqTfsK0nPUCEn6pje8WYXuGOM=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in

assert lib.assertMsg (hashes ? ${system}.hash.${phpMajor}) "blackfire does not support PHP version ${phpMajor} on ${system}.";

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
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
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
        createName = { phpMajor, system }:
          "php${builtins.replaceStrings [ "." ] [ "" ] phpMajor}_${system}";

        createUpdateable = sourceParams:
          lib.nameValuePair
            (createName sourceParams)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource sourceParams;
            }));
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
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
