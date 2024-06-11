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

  version = "1.92.17";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-BhAoC4q29toEq281aC2NRZ4uUhUDsl5QyiCh1dXpsLA=";
        "8.2" = "sha256-jgqTRr9fOQQ/+bbJvXKq6kPeFGvUTs7gfBpkpeeFhWs=";
        "8.3" = "sha256-McWJ+Ruyb7ySgDo8u7umgCjbh6dVd08wHYAxDMqjVGQ=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-LRYSUZUqkSbjs5UZzNGGQKvf1aGyixqRQV1SYa7ica0=";
        "8.2" = "sha256-VuPod48wx6rCSsZEV98AzqrD+a0t+yI0+9EifLjcROE=";
        "8.3" = "sha256-r7+IVjLx0hpPWPL0sRSIUd4sBye1avQ0IW00fLIhfEY=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-JQTqbWbFC3kEHuYQTXL70T7clIPZTje0E6LBAjyBQdc=";
        "8.2" = "sha256-uhm8SlbOwzd2HKUXha9jWoxYPzDEbiOo4GXQDby4BYA=";
        "8.3" = "sha256-w99LTLpkk6rvTXZU2Qwi5DA40Zyw2/c4060Beusfebk=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-sXxVKZSEL1VVFoh41hWwF1KR9hX2R7SwUQ4et+ouJYs=";
        "8.2" = "sha256-wA9oTpbUX967crg4Gq+AI04HtWmitodgTKNm1EEWltI=";
        "8.3" = "sha256-l7C7k/6tYfkUJ2qkeY52XjP6uDfXm0Mk/xM0hoRvsEM=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-SDS7JaktrW9z9R0jDwd+Q3W13KnPknuIoKaaJddORW8=";
        "8.2" = "sha256-pwFI4A4eUZKEZ5tDDlFTz5O+as7LXuyWdESgZI6soHQ=";
        "8.3" = "sha256-H++ksK3IjHDCbGD3BaVpWlKx8OH0G3Luktx2pu0GCj0=";
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
