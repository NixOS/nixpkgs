{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, addOpenGLRunpath
, makeWrapper
, ocl-icd
, vulkan-loader
}:

let
  inherit (stdenv.hostPlatform.uname) processor;
  version = "5.5.1";
  sources = {
    "x86_64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
      hash = "sha256-MgN+VcPcjzYP4Wt/uxiNMTh+p1mA5I2M8CgzDjI5xAQ=";
    };
    "aarch64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz";
      hash = "sha256-nrPKnsMqvw6+HGQAKxkQi/6lPEEca1VrDCaJUUuMvW8=";
    };
  };
in
stdenv.mkDerivation {
  inherit version;
  pname = "geekbench";

  src = fetchurl (sources.${stdenv.system});

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plar geekbench5 geekbench_${processor} $out/bin

    for f in geekbench5 geekbench_${processor} ; do
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
    platforms = builtins.attrNames sources;
    mainProgram = "geekbench5";
  };
}
