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

  version = "1.92.21";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-sEpoykSzgGGubXMUFrmxmYp1dNMfG6PfBb/tiMl/Tgs=";
        "8.2" = "sha256-ivF1SlzhnxpJEdTcia1GFsXd0etF5ItK13WzRIrf9n0=";
        "8.3" = "sha256-wonpCcbrvwo5xqKObZsr6eFNumv7E8vxvujXh7gSjtM=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-a6jkXJFHtsV0f8NC3ljeyQOjIASFBMuJA2hscX7j+QI=";
        "8.2" = "sha256-ASgWrfd0My4B3O0InOuMRaLPfVw4dgoqV4EJM1aEr2I=";
        "8.3" = "sha256-VRPEODt94DEwvrem7vNhpPt9i82HxB1UHup93GYcD5U=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-tSK+fhDQwSCTcrKQuvAe+JfHdCZIuneShvkz0rGunwM=";
        "8.2" = "sha256-38oZCy2BrcQ6Hg/q40iw+PdQ2p2QKyb08A3ZT9L6Ots=";
        "8.3" = "sha256-xEOV3dXu9AcDvm0qiUYVUySBTx7rTE0XFQdiSpDLY74=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-gRdtxGv3C30ZtYv7s8wspd/z21HWtMS+gw7MRt/77DA=";
        "8.2" = "sha256-jxEs6kGHHgswOHPmUM4UlYfJmH9f58zj6G19o00xQiQ=";
        "8.3" = "sha256-IFS/quwCWJkTogAK+GUzFNZYBkFupp06vskkueJA+Us=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-5Mbu0ppvpzC64zJ7MWFrOJeG33z4/f8SobLMywYiIOg=";
        "8.2" = "sha256-PDvGidy+Qjo+woeaWkTCJmEVymR9vTKCSoSb1YgSqCE=";
        "8.3" = "sha256-iwg+CMly70k8RWTPnJ7KPkIRKumxPlDjDZDzzElcruA=";
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
