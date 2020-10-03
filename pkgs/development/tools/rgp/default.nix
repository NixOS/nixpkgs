{ lib
, stdenv
, makeWrapper
, fetchurl
, autoPatchelfHook
, dbus
, fontconfig
, freetype
, glib
, libglvnd
, libX11
, libxcb
, libXi
, ncurses5
, qtbase
, qtdeclarative
, zlib
}:

let
  buildNum = "2020-09-11-26";
in
stdenv.mkDerivation rec {
  pname = "rgp";
  version = "1.8";

  src = fetchurl {
    url = "https://github.com/GPUOpen-Tools/radeon_gpu_profiler/releases/download/v${lib.versions.majorMinor version}/RadeonDeveloperTools-${buildNum}.tgz";
    sha256 = "1lpkh7sfpq697lm4xnkpjfchh8zpy49f4mb3c5qcn7brav5iqwfh";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libglvnd
    libX11
    libxcb
    libXi
    ncurses5
    qtbase
    qtdeclarative
    zlib
  ];

  runtimeDependencies = [
    "${placeholder "out"}/opt/rgp"
    "${placeholder "out"}/opt/rgp/qt"
  ];

  installPhase = ''
    mkdir -p $out/opt/rgp $out/bin
    cp -r . $out/opt/rgp/
    # Breaks autoPatchelfHook and has no known usage
    rm $out/opt/rgp/AMDToolsDownloader

    for prog in RadeonGPUProfiler RadeonDeveloperPanel RadeonDeveloperService RadeonDeveloperServiceCLI; do
      # makeWrapper is needed so that executables are started from the opt
      # directory, where qt.conf is
      makeWrapper \
        $out/opt/rgp/$prog \
        $out/bin/$prog
    done
  '';

  meta = with lib; {
    description = "A tool from AMD that allows for deep inspection of GPU workloads";
    homepage = "https://gpuopen.com/gaming-product/radeon-gpu-profiler-rgp/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
