{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  addOpenGLRunpath,
  makeWrapper,
  ocl-icd,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "4.4.4";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "sha256-KVsBE0ueWewmoVY/vzxX2sKhRTzityPNR+wmTwZBWiI=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plar geekbench4 geekbench_x86_64 $out/bin

    for f in geekbench4 geekbench_x86_64 ; do
      wrapProgram $out/bin/$f \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            addOpenGLRunpath.driverLink
            ocl-icd
            vulkan-loader
          ]
        }"
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
    mainProgram = "geekbench4";
  };
}
