{
  mkDerivation,
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
  qtbase,
  qmake,
  qtserialport,
  ctags,
  gdb,
}:

mkDerivation rec {
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

  meta = with lib; {
    description = "Graphical frontend (GUI) to GDB";
    mainProgram = "gede";
    homepage = "http://gede.dexar.se";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}
