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
<<<<<<< HEAD
  version = "6.1.0";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    hash = "sha256-GBJHnT6tfLdZuaawwhEvqOFYcmM42DZxRxm7cJNi0aA=";
=======
  version = "6.0.3";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    hash = "sha256-08c5YBKljeFo31Y7WHEnLLiJdFJm8RfkY2Q44C2dp7k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plar geekbench-workload.plar geekbench6 geekbench_x86_64 geekbench_avx2 $out/bin

    for f in geekbench6 geekbench_x86_64 geekbench_avx2 ; do
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
    mainProgram = "geekbench6";
  };
}
