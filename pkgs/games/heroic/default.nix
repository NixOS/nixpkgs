{ lib
, mkYarnPackage
, fetchFromGitHub
, makeWrapper
, electron
, gogdl
, legendary-gl
}:

mkYarnPackage rec {
  pname = "heroic-unwrapped";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    rev = "v${version}";
    sha256 = "sha256-x9zIM2kKi+JgIGIidQYjyjqVGweFJ8DE7IX9gYULQuQ=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [
    makeWrapper
  ];

  DISABLE_ESLINT_PLUGIN = "true";

  postBuild = let
    yarnCmd = "yarn --production --offline --frozen-lockfile --ignore-engines --ignore-scripts --lockfile ${yarnLock}";
  in ''
    ${yarnCmd} build-electron
    ${yarnCmd} build
  '';

  # Disable bundling into a tar archive.
  doDist = false;

  # --disable-gpu-compositing is to work around upstream bug
  # https://github.com/electron/electron/issues/32317
  postInstall = let
    deps = "$out/libexec/heroic/deps/heroic";
  in ''
    rm -rf "${deps}/public/bin" "${deps}/build/bin"
    mkdir -p "${deps}/public/bin/linux"
    ln -s "${gogdl}/bin/gogdl" "${legendary-gl}/bin/legendary" "${deps}/public/bin/linux"

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

  meta = with lib; {
    description = "A Native GOG and Epic Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aidalgol ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "heroic";
  };
}
