{
  lib,
  fetchurl,
  stdenv,
  versionCheckHook,

  common-updater-scripts,
  curl,
  gawk,
  gnugrep,
  gnupg,
  jq,
  writeShellScript,
}:

let
  pubring = import ./pubring.nix { inherit fetchurl; };
  # Node.js and Nix projects use different conventions to refer to the same platforms.
  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    powerpc64le-linux = "linux-ppc64le";
    s390x-linux = "linux-s390x";
    x86_64-linux = "linux-x64";
  };
  hashes = {
    aarch64-darwin = "d82a321541d65109c696505135be3b7dd46e3358f0f04d664f50f0d1e1ccb8a6";
    x86_64-darwin = "013a8f786a022ad1729cf435e3675e097a77d5a42eaf139a2d5d1d5309a027d4";
    aarch64-linux = "c827d3d301e2eed1a51f36d0116b71b9e3d9e3b728f081615270ea40faac34c1";
    powerpc64le-linux = "fb712a08d317655dbf776c90f60ac2105109d802e33811df6c9ed33d12f801c6";
    s390x-linux = "8e2c0d9b5545c3db22623e8cb8d6f0c28fcd470f29d32dbeabf9432dda289de2";
    x86_64-linux = "30215f90ea3cd04dfbc06e762c021393fa173a1d392974298bbc871a8e461089";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nodejs-repackaged";
  version = "24.13.1";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  dontBuild = true;

  # 4. Define how to install it
  installPhase = ''
    runHook preInstall

    install -Dm755 bin/* -t $out/bin
    cp -R include lib share $out/.

    mkdir -p $out/share/bash-completion/completions
    ln -s $out/lib/node_modules/npm/lib/utils/completion.sh \
      $out/share/bash-completion/completions/npm

    for dir in "$out/lib/node_modules/npm/man/"*; do
      mkdir -p $out/share/man/$(basename "$dir")
      for page in "$dir"/*; do
        ln -rs $page $out/share/man/$(basename "$dir")
      done
    done

    runHook postInstall
  '';

  dontPatchShebangs = true;
  postFixup = ''
    HOST_PATH=$out/bin patchShebangs --host $out
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    sources =
      let
        inherit (finalAttrs) version;
        downloadDir = if lib.strings.hasInfix "-rc." version then "download/rc" else "dist";
      in
      lib.listToAttrs (
        map (platform: {
          name = platform;
          value = fetchurl {
            url = "https://nodejs.org/${downloadDir}/v${version}/node-v${version}-${platformMap.${platform}}.tar.xz";
            sha256 = hashes.${platform};
          };
        }) (builtins.attrNames hashes)
      );
    updateScript = writeShellScript "nodejs-repackaged-update-script" ''
      set -o errexit
      PATH=${
        lib.makeBinPath [
          common-updater-scripts
          curl
          gawk
          gnugrep
          gnupg
          jq
        ]
      }
      version=$(
        curl --silent https://nodejs.org/download/release/index.json \
        | jq -r 'map(select(.lts)) | first | .version[1:]'
      )

      hashes=$(
        curl --silent "https://nodejs.org/dist/v''${version}/SHASUMS256.txt.asc" \
        | gpgv --keyring="${pubring}" --output -
      )

      ${builtins.concatStringsSep "\n" (
        map (nix_platform: ''
          update-source-version nodejs-repackaged "$version" "$(
            echo "$hashes" | awk '/${platformMap.${nix_platform}}.tar.xz/{ print $1 }'
          )" --ignore-same-version --source-key="sources.${nix_platform}"
        '') (builtins.attrNames platformMap)
      )}
    '';
  };

  meta = {
    description = "Repackage of the Node.js official binaries";
    homepage = "https://nodejs.org";
    changelog = "https://github.com/nodejs/node/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.aduh95 ];
    platforms = builtins.attrNames hashes;
    mainProgram = "node";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
