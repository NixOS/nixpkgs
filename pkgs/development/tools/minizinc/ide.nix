{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  qtwebsockets,
  minizinc,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
}:

let
  executableLoc =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/MiniZincIDE.app/Contents/MacOS/MiniZincIDE"
    else
      "$out/bin/MiniZincIDE";
in
stdenv.mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    hash = "sha256-ZESd83aqXr4vxEt9PvgarnELPi9BaEf68IUALYaTfzI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    makeWrapper
    copyDesktopItems
    imagemagick
  ];
  buildInputs = [
    qtbase
    qtwebsockets
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "MiniZincIDE";
      desktopName = "MiniZincIDE";
      icon = "minizinc";
      comment = meta.description;
      exec = "MiniZincIDE";
      type = "Application";
      terminal = false;
      categories = [
        "Science"
        "Development"
        "Education"
      ];
    })
  ];

  sourceRoot = "${src.name}/MiniZincIDE";

  dontWrapQtApps = true;

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/bin/MiniZincIDE.app $out/Applications/
    ''
    + ''
      wrapProgram ${executableLoc} \
        --prefix PATH ":" ${lib.makeBinPath [ minizinc ]} \
        --set QT_QPA_PLATFORM_PLUGIN_PATH "${qtbase}/lib/qt-6/plugins/platforms"

      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick -background none ${src}/MiniZincIDE/images/mznicon.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/minizinc.png
      done
    '';

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "IDE for MiniZinc, a medium-level constraint modelling language";
    mainProgram = "MiniZincIDE";
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.dtzWill ];
  };
}
