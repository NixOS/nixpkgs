{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nodejs-slim,
  rustPlatform,
  stdenv,
  testers,
  tests,
  writeScript,

  version,
  srcHash,
  cargoHash,
  knownVulnerabilities ? [ ],
}:
let
  majorVersion = lib.versions.major version;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pnpm";
  inherit version cargoHash;

  src = fetchFromGitHub {
    owner = "pnpm";
    repo = "pnpm";
    tag = "v${version}";
    hash = srcHash;
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  cargoBuildFlags = [
    "--bin=pnpm"
  ];

  postInstall = ''
    makeWrapper "$out"/bin/pnpm "$out"/bin/pnpx \
      --add-flag "dlx"

    ln -s "$out"/bin/pnpm "$out"/bin/pn
    ln -s "$out"/bin/pnpx "$out"/bin/pnx
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out"/bin/pnpm completion bash > pnpm.bash
    "$out"/bin/pnpm completion fish > pnpm.fish
    "$out"/bin/pnpm completion zsh > pnpm.zsh
    installShellCompletion pnpm.{bash,fish,zsh}
  '';

  passthru = {
    inherit majorVersion nodejs-slim;

    tests = {
      inherit (tests) pnpm;
      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };

    updateScript = writeScript "pnpm-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell --pure --keep GITHUB_TOKEN -i bash -p curl cacert jq nix-update git
      set -eou pipefail

      curl_github() {
        curl -L ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$@"
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

      nix-update pnpm_${majorVersion} --version="$latestVersion" --override-filename=./pkgs/development/tools/pnpm/default.nix
    '';
  };

  strictDeps = true;
  __structuredAttrs = true;

  # Tests take way too long to run
  doCheck = false;

  meta = {
    description = "Fast, disk space efficient package manager for JavaScript";
    homepage = "https://pnpm.io/";
    changelog = "https://github.com/pnpm/pnpm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      gepbird
    ];
    mainProgram = "pnpm";
    inherit knownVulnerabilities;
  };
})
