{ lib
, mkYarnPackage
, fetchFromGitHub
, gitUpdater
, makeWrapper
, electron
, gogdl
, legendary-gl
}:

mkYarnPackage rec {
  pname = "heroic-unwrapped";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    rev = "v${version}";
    sha256 = "sha256-vyZH/uOE7Oph8TuBFM2cUFwM4ed8Ri3fKRUrl9A6zHc=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [
    makeWrapper
  ];

  DISABLE_ESLINT_PLUGIN = "true";

  postBuild = let
    yarnCmd = "yarn --offline --frozen-lockfile --ignore-engines --ignore-scripts --lockfile ${yarnLock}";
  in ''
    rm deps/heroic/node_modules
    ln -s ../../node_modules deps/heroic/
    ${yarnCmd} vite build
  '';

  # Disable bundling into a tar archive.
  doDist = false;

  # --disable-gpu-compositing is to work around upstream bug
  # https://github.com/electron/electron/issues/32317
  postInstall = let
    deps = "$out/libexec/heroic/deps/heroic";
  in ''
    rm -rf "${deps}/public/bin" "${deps}/build/bin"
    mkdir -p "${deps}/build/bin/linux"
    ln -s "${gogdl}/bin/gogdl" "${legendary-gl}/bin/legendary" "${deps}/build/bin/linux"

    makeWrapper "${electron}/bin/electron" "$out/bin/heroic" \
      --inherit-argv0 \
      --add-flags --disable-gpu-compositing \
      --add-flags "${deps}"

    substituteInPlace "${deps}/flatpak/com.heroicgameslauncher.hgl.desktop" \
      --replace "Exec=heroic-run" "Exec=heroic"
    mkdir -p "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"
    ln -s "${deps}/flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications"
    ln -s "${deps}/flatpak/com.heroicgameslauncher.hgl.png" "$out/share/icons/hicolor/512x512/apps"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A Native GOG and Epic Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aidalgol ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "heroic";
  };
}
