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

  version = "1.92.18";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-5PVYDcyjarTG8RZaqEMvS8FK4DOw9goSaz9WZQtjvFo=";
        "8.2" = "sha256-2E+LmM0ZAkE4iIyo6Mxu8jJjX1aLHelsJRzM9Yo9D4g=";
        "8.3" = "sha256-Rm1E+ouUz50Wq4bjGnBwDpVN9C3JXu9zF6jmcrn6Xzg=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-iJucmU/ytes45VJAhsJHsvovbZ/mHtj+ChVv1vsL/XU=";
        "8.2" = "sha256-0Xc6d6ibfnkHEwwkseNWj52DesxVmBRD9oRZRS36XOI=";
        "8.3" = "sha256-x89Ub3LDstdzqdMDcF0mMpwDGufNDNRAp2yeZLNXnoQ=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-wESvg1iqPMvT9EjTNLJk5GtzgW80UigmR0m4Rr8VVaQ=";
        "8.2" = "sha256-/1hlgAVITlLM2i7aa3cIF/eci/q68rDT+wsB+zBxIzg=";
        "8.3" = "sha256-oABuQk6uZxC/Ry1DcpKbULso5CzEZEIod0GECxbLROk=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-hLPM07WVu1jPaaxR8YPeGcL05nrDG8LTVUJ9IoMKLWE=";
        "8.2" = "sha256-2gUmMr55r2FBMlmd/dyXQaXMEfod9tG8/QY0fo0NJxc=";
        "8.3" = "sha256-H+y1+671+V60GHHKP/0ss+A8t/h2HdGkRgARsqyJJ3M=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-Mm+CiC6dBb1JOs+Z/3dPSJNdKqvRLruYEFihsY52bpI=";
        "8.2" = "sha256-OXemTJV4exlTQj6MGBxMOA8TuXw3e6iXTD2i/gott2A=";
        "8.3" = "sha256-VtGUwhKAXr+P6+sn65Hyo8Dxh+Iyd/K3dwlqQmH0ElI=";
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
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
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
