{
  lib,
  stdenvNoCC,
  writeScript,
  callPackages,
  fetchurl,
  installShellFiles,
  nodejs,
  testers,
  withNode ? true,
  version,
  hash,
  buildPackages,
}:
let
  majorVersion = lib.versions.major version;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pnpm";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${finalAttrs.version}.tgz";
    inherit hash;
  };
  # Remove binary files from src, we don't need them, and this way we make sure
  # our distribution is free of binaryNativeCode
  preConfigure = ''
    rm -r dist/reflink.*node dist/vendor
  '';

  buildInputs = lib.optionals withNode [ nodejs ];

  nativeBuildInputs = [
    installShellFiles
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/{bin,libexec}
    cp -R . $out/libexec/pnpm
    ln -s $out/libexec/pnpm/bin/pnpm.cjs $out/bin/pnpm
    ln -s $out/libexec/pnpm/bin/pnpx.cjs $out/bin/pnpx

    runHook postInstall
  '';

  postInstall =
    if lib.toInt (lib.versions.major version) < 9 then
      ''
        export HOME="$PWD"
        node $out/bin/pnpm install-completion bash
        node $out/bin/pnpm install-completion fish
        node $out/bin/pnpm install-completion zsh
        sed -i '1 i#compdef pnpm' .config/tabtab/zsh/pnpm.zsh
        installShellCompletion \
          .config/tabtab/bash/pnpm.bash \
          .config/tabtab/fish/pnpm.fish \
          .config/tabtab/zsh/pnpm.zsh
      ''
    else
      ''
        node $out/bin/pnpm completion bash >pnpm.bash
        node $out/bin/pnpm completion fish >pnpm.fish
        node $out/bin/pnpm completion zsh >pnpm.zsh
        sed -i '1 i#compdef pnpm' pnpm.zsh
        installShellCompletion pnpm.{bash,fish,zsh}
      '';

  passthru =
    let
      fetchDepsAttrs = callPackages ./fetch-deps {
        pnpm = buildPackages."pnpm_${lib.versions.major version}";
      };
    in
    {
      inherit (fetchDepsAttrs) fetchDeps configHook;
      inherit majorVersion;

      tests.version = lib.optionalAttrs withNode (
        testers.testVersion { package = finalAttrs.finalPackage; }
      );
      updateScript = writeScript "pnpm-update-script" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl jq common-updater-scripts
        set -eou pipefail

        curl_github() {
            curl -L ''${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
        }

        latestTag=$(
          curl_github https://api.github.com/repos/pnpm/pnpm/releases?per_page=100 | \
          jq -r --arg major "v${majorVersion}" \
            '[.[] | select(.tag_name | startswith($major)) | select(.prerelease == false)][0].tag_name'
        )

        # Exit if there is no tag with this major version
        if [ "$latestTag" = "null" ]; then
          echo "No releases starting with v${majorVersion}"
          exit 0
        fi

        latestVersion="''${latestTag#v}"

        update-source-version pnpm_${majorVersion} "$latestVersion" --file=./pkgs/development/tools/pnpm/default.nix
      '';
    };

  meta = {
    description = "Fast, disk space efficient package manager for JavaScript";
    homepage = "https://pnpm.io/";
    changelog = "https://github.com/pnpm/pnpm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      gepbird
    ];
    platforms = lib.platforms.all;
    mainProgram = "pnpm";
  };
})
