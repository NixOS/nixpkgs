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

  version = "1.92.28";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-zJ6SOBGLzu3C47P9BrQCQjPVSpZq3PPLPfhXjL7Rnns=";
        "8.2" = "sha256-jiHmAs2O047sjOzOTk/k2VQXBz6OT+kBlTElW3TSZjU=";
        "8.3" = "sha256-yop48pyCT/904Sh9hQTCVagc38giLDDZJebtdTRQV3w=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-wK/P+4K0fmyzIsrp360TaNSxiols5KVIvMY6ABdXN+s=";
        "8.2" = "sha256-jJId/K7+27UbCMeWwT1Z0sMOe6Uj2Gw6FgBTv794rwQ=";
        "8.3" = "sha256-Am8UKQCxAn2up4laZ/u55vVKIJSdunuc85amSWQg8wI=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-JtEKfZnPqWCBUUHrhlnc/My+zllVySiJlsgdSYP3s5A=";
        "8.2" = "sha256-FMd17GarNGlCO5a9X4I1SVo0qKIjsBaJMtLCcoi/uvk=";
        "8.3" = "sha256-ZFckNiN0cAQEoc7m53MH/fiTNrWTLzIDzjpvsSbd0Xo=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-fI1ACatqdKQJqh5fBWC1ikLUEsXfqegJlJWUDQYiI2w=";
        "8.2" = "sha256-BhSL2ee1viVKoS3R1F/kuHgzyojDk3Pxrvor/xQ3b+4=";
        "8.3" = "sha256-fZk0n/nUSOyQNXhUObGwZj0n7MBM7RS86ShKkEfRDws=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-YglriIPnixhsg1wlLHyu17CUETVEPOenu41Gq7maewU=";
        "8.2" = "sha256-zvucvA2w1gQMApud2ozIK5BY4noSUooruRXjevELeBw=";
        "8.3" = "sha256-hMRZHO4sVZCVHBifyVAD2b59Be8teqx+/QKH+ytQKuI=";
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
