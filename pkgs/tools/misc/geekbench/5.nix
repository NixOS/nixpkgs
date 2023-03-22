{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, addOpenGLRunpath
, makeWrapper
, ocl-icd
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "5.5.1";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "sha256-MgN+VcPcjzYP4Wt/uxiNMTh+p1mA5I2M8CgzDjI5xAQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plar geekbench5 geekbench_x86_64 $out/bin

    for f in geekbench5 geekbench_x86_64 ; do
      wrapProgram $out/bin/$f \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
          addOpenGLRunpath.driverLink
          ocl-icd
          vulkan-loader
       ]}"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "geekbench5";
  };
}
