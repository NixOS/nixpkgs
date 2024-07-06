{ lib
, buildPythonApplication
, fetchFromGitHub
, mkYarnModules
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, pythonOlder
, setuptools
, pyqt5
, pyqtwebengine
, six
, requests
, requests-toolbelt
, raven
, ply
, semantic-version
, token-bucket
, ninja
, SDL2
, openal
, p7zip
, nodejs
, qt5
, appimage-run
}:

let
  pname = "fs2-knossos";
  version = "0.14.3";

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };
in buildPythonApplication rec {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.6";

  # The rewrite is not yet in working order, but will eventually replace this.
  # See: https://github.com/ngld/knossos
  src = fetchFromGitHub {
    owner = "ngld";
    repo = "old-knossos";
    rev = "v${version}";
    hash = "sha256-2lTJjEzFKtFwNmqkAm3C98mX59WrAU2I/Z5ypJcA4Zk=";
  };

  nativeBuildInputs = [
    setuptools
    ninja
    nodejs
    p7zip
    qt5.qttools.dev
    qt5.wrapQtAppsHook
    copyDesktopItems
    makeWrapper
  ];

  propagatedBuildInputs = [
    pyqt5
    pyqtwebengine
    six
    requests
    requests-toolbelt
    raven
    ply
    semantic-version
    token-bucket
    SDL2
    openal
    p7zip
    qt5.qtwayland
    appimage-run
  ];

  libPath = lib.makeLibraryPath [ SDL2 openal ];

  postPatch = ''
    # Doesn't account for libopenal links like with SDL...
    substituteInPlace configure.py knossos/clibs.py \
      --replace "'openal'" "'libopenal.so.1', 'openal'"

    # FS2Open uses appimage, so we need to prepend appimage-run.
    substituteInPlace knossos/runner.py \
      --replace "[fs2_bin]" "[\"${appimage-run}/bin/appimage-run\", fs2_bin]"
  '';

  preConfigure = ''
    export HOME="$(mktemp -d)";
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${libPath}
    export NODE_OPTIONS=--openssl-legacy-provider
    ln -s ${yarnDeps}/node_modules .
    python configure.py
    ninja resources
  '';

  postInstall = ''
    mkdir -p $out/share/{licenses/knossos,pixmaps}
    cp LICENSE $out/share/licenses/knossos
    cp NOTICE $out/share/licenses/knossos
    cp knossos/data/hlp.png $out/share/pixmaps/knossos.png
    # Preload openal or else it's not detected, unlike SDL...
    wrapProgram $out/bin/knossos --prefix LD_LIBRARY_PATH : ${libPath} --set LD_PRELOAD ${openal}/lib/libopenal.so.1
  '';

  desktopItems = [(makeDesktopItem {
    name = "knossos";
    desktopName = "Knossos";
    type = "Application";
    icon = "knossos";
    exec = "knossos %U";
    comment = "Mod launcher/installer for Freespace Open";
    categories = [ "Game" ];
    mimeTypes = [ "x-scheme-handler/fso" ];
    terminal = false;
  })];

  pythonImportsCheck = [ "knossos" ];
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Mod launcher/installer for Freespace Open";
    homepage = "https://fsnebula.org/knossos/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux; # Compatible with OSX and Windows, but I'm not implementing it.
  };
}
