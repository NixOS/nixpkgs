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
  buildNum = "2022-04-20-920";
in
stdenv.mkDerivation rec {
  pname = "rgp";
  version = "1.13";

  src = fetchurl {
    url = "https://gpuopen.com/download/radeon-developer-tool-suite/RadeonDeveloperToolSuite-${buildNum}.tgz";
    hash = "sha256-/Z7mSZVAvaTAY9RU7suK/gA0RJIeeLdN6LWiseVq9Js=";
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
