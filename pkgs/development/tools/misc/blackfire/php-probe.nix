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

  version = "1.92.29";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-82QSfFeXkE6+jQZpQ53RtSrQkk4fKmFUdMxpjPyoH+I=";
        "8.2" = "sha256-DdmXnMeE4FXdi8fDCeApwHnmoLZK5x7F5aDzi2PAoPk=";
        "8.3" = "sha256-cx+BesBkumuKThWGQWjgz1IvRo4iem/PlFH8V1kGRt0=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-jJm0DL4nXPW0jW6w+bhRolWGvQEzcKKp3t7Aj6Yyh4E=";
        "8.2" = "sha256-PcEzgoj+mnpK9CpHFW74lOrjoqbd9FBRO+ewplEkAlc=";
        "8.3" = "sha256-Iv7y86hQd53j3I5MSmMQkq67Yv4sGPcS0Ljo7TigNUk=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-mgaaU/XpdLx1cYR/Dg09BCeMvV/Hfum0/9P2prHr/08=";
        "8.2" = "sha256-QxIp4DCe5yqs32T0G8L1im5UHpJYcmVbHzJAAt/fa7o=";
        "8.3" = "sha256-esR9wZ2I5gTGmBQgPqdDPkPGJED/stoZQUpUiWp0cNY=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-LkbqZytdpaLU7eVwnI3dBY+a6+diMtKot/8PH1E9UpY=";
        "8.2" = "sha256-IwFFVZ+ED/SVvl+Qj7F0BQ2yoLmbBKYHCzMPXlcffPY=";
        "8.3" = "sha256-tcgfKgFnx8Cc3OvFWVObqV9nwH+F1ts1+TNfMTf/AI0=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-X+uLHJDA7wzXq0r+ZJu+XCxK8Lna2TKA+BhncFT7Jzw=";
        "8.2" = "sha256-x8ejkI7qGUeii2Q6rWIOpLhgOTRQnh484asxo9un6aY=";
        "8.3" = "sha256-FSh8fJv6+inpw7xdRIsU7cNLr5OyzLt0kAjeKa1aJX0=";
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
