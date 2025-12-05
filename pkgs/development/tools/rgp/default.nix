{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  autoPatchelfHook,
  dbus,
  directx-shader-compiler,
  fontconfig,
  freetype,
  glib,
  libdrm,
  libGLU,
  libglvnd,
  libICE,
  libkrb5,
  libSM,
  libX11,
  libxcb,
  libXi,
  libxkbcommon,
  libxml2_13,
  ncurses,
  wayland,
  xcbutil,
  zlib,
}:

let
  buildNum = "2025-06-12-1681";
in
stdenv.mkDerivation {
  pname = "rgp";
  version = "2.5";

  src = fetchurl {
    url = "https://gpuopen.com/download/radeon-developer-tool-suite/RadeonDeveloperToolSuite-${buildNum}.tgz";
    hash = "sha256-e7IxoaZi77klrihRO6vDh1o2Clj5lNsVlzQ7btgLsu4=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    directx-shader-compiler
    fontconfig
    freetype
    glib
    libdrm
    libGLU
    libglvnd
    libICE
    libkrb5
    libSM
    libX11
    libxcb
    libXi
    libxkbcommon
    libxml2_13
    ncurses
    wayland
    xcbutil
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
      makeWrapper \
        $out/opt/rgp/$prog \
        $out/bin/$prog \
        --unset QT_QPA_PLATFORMTHEME \
        --unset QT_STYLE_OVERRIDE \
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
