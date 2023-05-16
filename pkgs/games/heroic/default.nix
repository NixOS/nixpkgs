{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
<<<<<<< HEAD
=======
, fetchpatch
, gitUpdater
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, yarn
, fixup_yarn_lock
, nodejs
, python3
, makeWrapper
, electron
, gogdl
, legendary-gl
<<<<<<< HEAD
, nile
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let appName = "heroic";
in stdenv.mkDerivation rec {
  pname = "heroic-unwrapped";
<<<<<<< HEAD
  version = "2.9.1";
=======
  version = "2.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1FtAcp6cG2qRfWrAgCOQ87DzMvszqqhObfSzepezBGc=";
=======
    sha256 = "sha256-l2eVLn1N+1nGxr8Oa2ecQgBmO0w/VJ8AY06GYQ0HiiI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
<<<<<<< HEAD
    hash = "sha256-KEzTjtoBcHNJxC/7W/Bft75JZuZUSHieOOAwhbr5d3s=";
  };

=======
    sha256 = "sha256-R0lZrVfUH8NucuwarcE47jQ8ex5FY2hK6jJJ2TIRSWY=";
  };

  patches = [
    # Fix for capturing keyboard shortcuts when not in focus.
    # TODO: Remove when updating past 2.7.1.
    (fetchpatch {
      url = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/commit/c82e6ca8dd7070071793fe5a3c4c04b4ae02c3c7.patch";
      hash = "sha256-Pum67YPejfq8ERv6XWVLQzs+/SyNojmTGTQpE0UR4kg=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    yarn
    fixup_yarn_lock
    nodejs
    python3
    makeWrapper
  ];

<<<<<<< HEAD
  patches = [
    # Reverts part of upstream PR 2761 so that we don't have to use a non-free Electron fork.
    # https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/pull/2761
    ./remove-drm-support.patch
    # Make Heroic create Steam shortcuts (to non-steam games) with the correct path to heroic.
    ./fix-non-steam-shortcuts.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline vite build

    # Remove dev dependencies.
    yarn install --production --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postBuild
  '';

  # --disable-gpu-compositing is to work around upstream bug
  # https://github.com/electron/electron/issues/32317
  installPhase = let
    binPlatform = if stdenv.isDarwin then "darwin" else "linux";
  in ''
    runHook preInstall

    mkdir -p $out/share/{applications,${appName}}
    cp -r . $out/share/${appName}
    rm -rf $out/share/${appName}/{.devcontainer,.vscode,.husky,.idea,.github}

    chmod -R u+w "$out/share/${appName}/public/bin" "$out/share/${appName}/build/bin"
    rm -rf "$out/share/${appName}/public/bin" "$out/share/${appName}/build/bin"
    mkdir -p "$out/share/${appName}/build/bin/${binPlatform}"
<<<<<<< HEAD
    ln -s \
      "${gogdl}/bin/gogdl" \
      "${legendary-gl}/bin/legendary" \
      "${nile}"/bin/nile \
      "$out/share/${appName}/build/bin/${binPlatform}"
=======
    ln -s "${gogdl}/bin/gogdl" "${legendary-gl}/bin/legendary" "$out/share/${appName}/build/bin/${binPlatform}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    makeWrapper "${electron}/bin/electron" "$out/bin/heroic" \
      --inherit-argv0 \
      --add-flags --disable-gpu-compositing \
      --add-flags $out/share/${appName} \
<<<<<<< HEAD
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"
=======
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    substituteInPlace "$out/share/${appName}/flatpak/com.heroicgameslauncher.hgl.desktop" \
      --replace "Exec=heroic-run" "Exec=heroic"
    mkdir -p "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"
    ln -s "$out/share/${appName}/flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications"
    ln -s "$out/share/${appName}/flatpak/com.heroicgameslauncher.hgl.png" "$out/share/icons/hicolor/512x512/apps"

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = with lib; {
    description = "A Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac";
=======
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A Native GOG and Epic Games Launcher for Linux, Windows and Mac";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    changelog = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aidalgol ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = appName;
  };
}
