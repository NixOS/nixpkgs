{
  lib,
  stdenv,
  buildGoModule,
  rustPlatform,
  fetchFromGitHub,
  fetchYarnDeps,

  cargo-tauri,
  installShellFiles,
  makeBinaryWrapper,
  nodejs,
  pkg-config,
  yarnConfigHook,

  libayatana-appindicator,
  libsoup,
  openssl,
  webkitgtk_4_0,

  testers,
}:

let
  version = "0.5.20";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devpod";
    rev = "refs/tags/v${version}";
    hash = "sha256-8LbqrOKC1als3Xm6ZuU2AySwT0UWjLN2xh+/CvioYew=";
  };

  meta = {
    description = "Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker";
    mainProgram = "devpod";
    homepage = "https://devpod.sh";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      maxbrunet
      tomasajt
    ];
  };
in
rec {
  devpod = buildGoModule {
    pname = "devpod";
    inherit version src meta;

    vendorHash = null;

    CGO_ENABLED = 0;

    ldflags = [
      "-X github.com/loft-sh/devpod/pkg/version.version=v${version}"
    ];

    excludedPackages = [ "./e2e" ];

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      $out/bin/devpod completion bash >devpod.bash
      $out/bin/devpod completion fish >devpod.fish
      $out/bin/devpod completion zsh >devpod.zsh
      installShellCompletion devpod.{bash,fish,zsh}
    '';

    passthru.tests.version = testers.testVersion {
      package = devpod;
      command = "devpod version";
      version = "v${version}";
    };
  };

  devpod-desktop = rustPlatform.buildRustPackage {
    pname = "devpod-desktop";
    inherit version src;

    sourceRoot = "${src.name}/desktop";

    cargoRoot = "src-tauri";
    buildAndTestSubdir = "src-tauri";

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "tauri-plugin-log-0.0.0" = "sha256-tM6oLJe/wwqDDNMKBeMa5nNVvsmi5b104xMOvtm974Y=";
      };
    };

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/desktop/yarn.lock";
      hash = "sha256-vUV4yX+UvEKrP0vHxjGwtW2WyONGqHVmFor+WqWbkCc=";
    };

    postPatch = ''
      # set up the tauri sidecar binary (tauri sidecar files need a suffix)
      # unfortunately tauri will not copy this as a symlink, so we'll replace it manually later
      ln -s ${lib.getExe devpod} src-tauri/bin/devpod-cli-${stdenv.hostPlatform.rust.rustcTarget}

      # disable the button that symlinks the `devpod-cli` binary to ~/.local/bin/devpod
      # we'll symlink it manually later to $out/bin/devpod
      substituteInPlace src/components/useInstallCLI.tsx --replace-fail \
        'isDisabled={status === "success"}>' \
        'isDisabled={true}>'

      # don't show popup where it prompts you to press the above mentioned button
      substituteInPlace src/client/client.ts --replace-fail \
        'public async isCLIInstalled(): Promise<Result<boolean>> {' \
        'public async isCLIInstalled(): Promise<Result<boolean>> { return Return.Value(true);'

      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
          --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
      ''}
    '';

    nativeBuildInputs = [
      yarnConfigHook
      nodejs

      pkg-config
      cargo-tauri.hook
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      libayatana-appindicator
      libsoup
      openssl
      webkitgtk_4_0
    ];

    postInstall = ''
      sidecar_path="$out/bin/devpod-cli"

      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        sidecar_path="$out/Applications/DevPod.app/Contents/MacOS/devpod-cli"
      ''}

      # replace sidecar binary with symlink
      ln -sf ${lib.getExe devpod} "$sidecar_path"

      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        makeWrapper "$out"/Applications/DevPod.app/Contents/MacOS/DevPod "$out/bin/dev-pod"
      ''}

      # propagate the `devpod` command
      ln -s ${lib.getExe devpod} "$out/bin/devpod"
    '';

    meta = meta // {
      mainProgram = "dev-pod";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
}
