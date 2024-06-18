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
, libICE
, libkrb5
, libSM
, libX11
, libxcb
, libXi
, libxkbcommon
, ncurses
, zlib
}:

let
  buildNum = "2023-12-04-1282";
in
stdenv.mkDerivation {
  pname = "rgp";
  version = "2.0";

  src = fetchurl {
    url = "https://gpuopen.com/download/radeon-developer-tool-suite/RadeonDeveloperToolSuite-${buildNum}.tgz";
    hash = "sha256-gGkINq0tmOCkZJMxtoURHikqEGXGuRAP6Y6PEOLqmI0=";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libGLU
    libglvnd
    libICE
    libkrb5
    libSM
    libX11
    libxcb
    libXi
    libxkbcommon
    ncurses
    zlib
  ];

  installPhase = ''
    mkdir -p $out/opt/rgp $out/bin
    cp -r . $out/opt/rgp/

    chmod +x $out/opt/rgp/scripts/*
    patchShebangs $out/opt/rgp/scripts

    for prog in RadeonDeveloperPanel RadeonDeveloperService RadeonDeveloperServiceCLI RadeonGPUAnalyzer RadeonGPUProfiler RadeonMemoryVisualizer RadeonRaytracingAnalyzer rga rtda; do
      # makeWrapper is needed so that executables are started from the opt
      # directory, where qt.conf and other tools are.
      # Unset Qt theme, it does not work if the nixos Qt version is different from the packaged one.
      # The packaged Qt version only supports X11, so enforce that.
      makeWrapper \
        $out/opt/rgp/$prog \
        $out/bin/$prog \
        --unset QT_QPA_PLATFORMTHEME \
        --unset QT_STYLE_OVERRIDE \
        --set QT_QPA_PLATFORM xcb \
        --prefix LD_LIBRARY_PATH : $out/opt/rgp/lib
    done
  '';

  meta = with lib; {
    description = "Tool from AMD that allows for deep inspection of GPU workloads";
    homepage = "https://gpuopen.com/rgp/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
