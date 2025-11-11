{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  qttools,
  libGLU,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "nifskope";
  version = "2.0.dev11-20251031";

  src = fetchFromGitHub {
    owner = "fo76utils";
    repo = "nifskope";
    rev = "v${version}";
    hash = "sha256-m8M4Hqvoza5JfAsbDIETVP4CS8gPd/Wxna0Sg9I4Gok=";
    fetchSubmodules = true;
  };

  buildInputs = [
    qtbase
    qttools
    libGLU
  ];
  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  preConfigure = ''
    shopt -s globstar
    for i in **/*.cpp; do
      substituteInPlace $i --replace /usr/share/nifskope $out/share/nifskope
    done
  '';

  # Inspired by install/linux-install/nifskope.spec.in.
  installPhase = ''
    runHook preInstall

    d=$out/share/nifskope
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $d/{shaders,lang}
    cp release/NifSkope $out/bin/
    cp ./res/nifskope.png $out/share/pixmaps/
    cp release/{nif.xml,kfm.xml,style.qss} $d/
    cp res/shaders/* $d/shaders/
    cp ./res/lang/*.ts ./res/lang/*.tm $d/lang/
    cp ./install/linux-install/nifskope.desktop $out/share/applications

    substituteInPlace $out/share/applications/nifskope.desktop \
      --replace 'Exec=nifskope' "Exec=$out/bin/NifSkope" \
      --replace 'Icon=nifskope' "Icon=$out/share/pixmaps/nifskope.png"

    find $out/share -type f -exec chmod -x {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/fo76utils/nifskope";
    description = "Tool for analyzing and editing NetImmerse/Gamebryo '*.nif' files";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "NifSkope";
  };
}
