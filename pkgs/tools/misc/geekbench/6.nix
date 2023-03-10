{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, linuxPackages
, ocl-icd
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "6.0.1";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    hash = "sha256-RrfyB7RvYWkVCbjblLIPOFcZjUR/fJHk1Em1HP74kmY=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    linuxPackages.nvidia_x11
    ocl-icd
    vulkan-loader
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r geekbench.plar geekbench-workload.plar geekbench6 geekbench_x86_64 geekbench_avx2 $out/bin
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
