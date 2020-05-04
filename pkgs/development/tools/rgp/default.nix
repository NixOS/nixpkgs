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
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rgp";
  version = "1.7.0.29";

  src = fetchurl {
    url = "https://github.com/GPUOpen-Tools/radeon_gpu_profiler/releases/download/v${lib.versions.majorMinor version}/RadeonGPUProfiler_${version}.tgz";
    sha256 = "d7d4aa92231796a509dfcf92e9618cac98ae6572c12efd0871eb43afa4e8240a";
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
