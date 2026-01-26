{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
  qtbase,
  qmake,
  qtserialport,
  wrapQtAppsHook,
  ctags,
  gdb,
}:

stdenv.mkDerivation rec {
  pname = "gede";
  version = "2.22.1";

  src = fetchFromGitHub {
    owner = "jhn98032";
    repo = "gede";
    tag = "v${version}";
    hash = "sha256-6YSrqLDuV4G/uvtYy4vzbwqrMFftMvZdp3kr3R436rs=";
  };

  nativeBuildInputs = [
    ctags
    makeWrapper
    python3
    qmake
    qtserialport
    wrapQtAppsHook
  ];

  strictDeps = true;

  dontUseQmakeConfigure = true;

  dontBuild = true;

  installPhase = ''
    python build.py install --verbose --prefix="$out"
    wrapProgram $out/bin/gede \
      --prefix QT_PLUGIN_PATH : ${qtbase}/${qtbase.qtPluginPrefix} \
      --prefix PATH : ${
        lib.makeBinPath [
          ctags
          gdb
        ]
      }
  '';

  meta = {
    description = "Graphical frontend (GUI) to GDB";
    mainProgram = "gede";
    homepage = "http://gede.dexar.se";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ juliendehos ];
  };
}
