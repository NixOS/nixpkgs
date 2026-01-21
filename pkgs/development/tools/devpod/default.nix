{
  lib,
  stdenv,
  buildGoModule,
  rustPlatform,
  fetchFromGitHub,
  fetchYarnDeps,

  cargo-tauri,
  desktop-file-utils,
  installShellFiles,
  jq,
  makeBinaryWrapper,
  moreutils,
  nodejs,
  pkg-config,
  yarnConfigHook,
  wrapGAppsHook3,

  glib-networking,
  libayatana-appindicator,
  openssl,
  webkitgtk_4_1,

  testers,
}:

let
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devpod";
    tag = "v${version}";
    hash = "sha256-fLUJeEwNDyzMYUEYVQL9XGQv/VAxjH4IZ1SJa6jx4Mw=";
  };

  meta = {
    description = "Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker";
    mainProgram = "devpod";
    homepage = "https://devpod.sh";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.tomasajt ];
  };

  devpod = buildGoModule (finalAttrs: {
    pname = "devpod";
    inherit version src meta;

    vendorHash = null;

    env.CGO_ENABLED = 0;

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
      package = finalAttrs.finalPackage;
      command = "devpod version";
      version = "v${version}";
    };
  });

  devpod-desktop = rustPlatform.buildRustPackage {
    pname = "devpod-desktop";
    inherit version src;

    sourceRoot = "${src.name}/desktop";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/desktop/yarn.lock";
      hash = "sha256-0Ov+Ik+th2IiuuqJyiO9t8vTyMqxDa9juEwbwHFaoi4=";
    };

    cargoRoot = "src-tauri";
    buildAndTestSubdir = "src-tauri";

    cargoHash = "sha256-PSgBwa8sZ85W2kBrXkFVvnoYn5l1r3Jvn/LG8tITjbU=";

    cargoPatches = [ ./cargo-lock.patch ];

    patches = [
      # don't create a .desktop file automatically registered to open the devpod:// URI scheme
      # we edit the in-store .desktop file in postInstall to support opening the scheme,
      # but users will have to configure the default handler manually
      ./dont-auto-register-scheme.patch

      # disable the button that symlinks the `devpod-cli` binary to ~/.local/bin/devpod
      # and don't show popup where it prompts you to press the above mentioned button
      # we'll symlink it manually to $out/bin/devpod in postInstall
      ./dont-copy-sidecar-out-of-store.patch

      # otherwise it's going to get stuck in an endless error cycle, quickly increasing the log file size
      ./exit-update-checker-loop.patch
    ];

    postPatch = ''
      ln -s ${lib.getExe devpod} src-tauri/bin/devpod-cli-${stdenv.hostPlatform.rust.rustcTarget}

      # disable upstream updater
      jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json \
        | sponge src-tauri/tauri.conf.json
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    nativeBuildInputs = [
      cargo-tauri.hook
      jq
      moreutils
      nodejs
      yarnConfigHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      desktop-file-utils
      pkg-config
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeBinaryWrapper
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libayatana-appindicator
      openssl
      webkitgtk_4_1
    ];

    postInstall =
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        # replace sidecar binary with symlink
        ln -sf ${lib.getExe devpod} "$out/Applications/DevPod.app/Contents/MacOS/devpod-cli"

        makeWrapper "$out/Applications/DevPod.app/Contents/MacOS/DevPod Desktop" "$out/bin/DevPod Desktop"
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        # replace sidecar binary with symlink
        ln -sf ${lib.getExe devpod} "$out/bin/devpod-cli"

        # set up scheme handling
        desktop-file-edit "$out/share/applications/DevPod.desktop" \
          --set-key="Exec"     --set-value="\"DevPod Desktop\" %u" \
          --set-key="MimeType" --set-value="x-scheme-handler/devpod"

        # whitespace in the icon name causes gtk-update-icon-cache to fail
        desktop-file-edit "$out/share/applications/DevPod.desktop" \
          --set-key="Icon"     --set-value="DevPod-Desktop"

        for dir in "$out"/share/icons/hicolor/*/apps; do
          mv "$dir/DevPod Desktop.png" "$dir/DevPod-Desktop.png"
        done
      ''
      + ''
        # propagate the `devpod` command
        ln -s ${lib.getExe devpod} "$out/bin/devpod"
      '';

    # we only want to wrap the main binary
    dontWrapGApps = true;

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapGApp "$out/bin/DevPod Desktop"
    '';

    meta = meta // {
      mainProgram = "DevPod Desktop";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
in
{
  inherit devpod devpod-desktop;
}
