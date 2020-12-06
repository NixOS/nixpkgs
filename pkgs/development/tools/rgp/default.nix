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
, ncurses5
, qtbase
, qtdeclarative
, zlib
}:

let
  buildNum = "2020-11-19-376";
in
stdenv.mkDerivation rec {
  pname = "rgp";
  version = "1.9";

  src = fetchurl {
    url = "https://gpuopen.com/download/radeon-developer-tool-suite/RadeonDeveloperToolSuite-${buildNum}.tgz";
    sha256 = "f71ibuMerd0SmXKSDjaTj7xtyy1dWzkZ5s0PlGtQ1+k=";
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
