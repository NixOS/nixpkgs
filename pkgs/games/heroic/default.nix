{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  makeWrapper,
  electron,
  vulkan-helper,
  gogdl,
  legendary-gl,
  nile,
  comet-gog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "heroic-unwrapped";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+OQRcBOf9Y34DD7FOp/3SO05mREG6or/HPiOkasHWPM=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3PiB8CT7wxGmvRuQQ5FIAmBqBm9+R55ry+N/qUYWzuk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
  ];

  patches = [
    # Make Heroic create Steam shortcuts (to non-steam games) with the correct path to heroic.
    ./fix-non-steam-shortcuts.patch
  ];

  postPatch = ''
    # We are not packaging this as an Electron application bundle, so Electron
    # reports to the application that is is not "packaged", which causes Heroic
    # to take some incorrect codepaths meant for development environments.
    substituteInPlace src/**/*.ts --replace-quiet 'app.isPackaged' 'true'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm --offline electron-vite build
    # Remove dev dependencies.
    pnpm --ignore-scripts prune --prod
    # Clean up broken symlinks left behind by `pnpm prune`
    find node_modules/.bin -xtype l -delete

    runHook postBuild
  '';

  # --disable-gpu-compositing is to work around upstream bug
  # https://github.com/electron/electron/issues/32317
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,heroic}
    cp -r . $out/share/heroic
    rm -rf $out/share/heroic/{.devcontainer,.vscode,.husky,.idea,.github}

    chmod -R u+w "$out/share/heroic/public/bin" "$out/share/heroic/build/bin"
    rm -rf "$out/share/heroic/public/bin" "$out/share/heroic/build/bin"
    mkdir -p "$out/share/heroic/build/bin/x64/linux"
    ln -s \
      "${lib.getExe gogdl}" \
      "${lib.getExe legendary-gl}" \
      "${lib.getExe nile}" \
      "${lib.getExe comet-gog}" \
      "${lib.getExe vulkan-helper}" \
      "$out/share/heroic/build/bin/x64/linux/"

    makeWrapper "${electron}/bin/electron" "$out/bin/heroic" \
      --inherit-argv0 \
      --add-flags --disable-gpu-compositing \
      --add-flags $out/share/heroic \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"

    substituteInPlace "$out/share/heroic/flatpak/com.heroicgameslauncher.hgl.desktop" \
      --replace-fail "Exec=heroic-run" "Exec=heroic"
    mkdir -p "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"
    ln -s "$out/share/heroic/flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications"
    ln -s "$out/share/heroic/flatpak/com.heroicgameslauncher.hgl.png" "$out/share/icons/hicolor/512x512/apps"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    changelog = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aidalgol ];
    # Heroic may work on nix-darwin, but it needs a dedicated maintainer for the platform.
    # It may also work on other Linux targets, but all the game stores only
    # support x86 Linux, so it would require extra hacking to run games via QEMU
    # user emulation.  Upstream provide Linux builds only for x86_64.
    platforms = [ "x86_64-linux" ];
    mainProgram = "heroic";
  };
})
