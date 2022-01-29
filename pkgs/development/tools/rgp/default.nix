{ lib
, stdenv
, makeWrapper
, fetchurl
, autoPatchelfHook
, dbus
, fontconfig
, freetype
, glib
, libGLU
, libglvnd
, libX11
, libxcb
, libXi
, ncurses
, qtbase
, qtdeclarative
, zlib
}:

let
  buildNum = "2022-01-18-884";
in
stdenv.mkDerivation rec {
  pname = "rgp";
  version = "1.12";

  src = fetchurl {
    url = "https://gpuopen.com/download/radeon-developer-tool-suite/RadeonDeveloperToolSuite-${buildNum}.tgz";
    sha256 = "88ot16N8XtRlDCP+zIaOqG5BuR0OyG/0u1NEXsun/nY=";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libGLU
    libglvnd
    libX11
    libxcb
    libXi
    ncurses
    qtbase
    qtdeclarative
    zlib
  ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/opt/rgp $out/bin
    cp -r . $out/opt/rgp/

    chmod +x $out/opt/rgp/scripts/*
    patchShebangs $out/opt/rgp/scripts

    for prog in RadeonDeveloperPanel RadeonDeveloperService RadeonDeveloperServiceCLI RadeonGPUAnalyzer RadeonGPUProfiler rga rtda; do
      # makeWrapper is needed so that executables are started from the opt
      # directory, where qt.conf and other tools are
      makeWrapper \
        $out/opt/rgp/$prog \
        $out/bin/$prog
    done
  '';

  meta = with lib; {
    description = "A tool from AMD that allows for deep inspection of GPU workloads";
    homepage = "https://gpuopen.com/rgp/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
