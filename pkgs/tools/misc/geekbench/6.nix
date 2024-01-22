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
  version = "6.2.2";
  sources = {
    "x86_64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
      hash = "sha256-s+Wkji9kYrrFN6Kuwem5GSibeVv0ArsEigMV4vFJh0w=";
    };
    "aarch64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz";
      hash = "sha256-osRnqiJqfoDNy2hSHGKjKqf5o0Yz8n+tq45VFuzsKqY=";
    };
  };
  geekbench_avx2 = lib.optionalString stdenv.isx86_64 "geekbench_avx2";
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
    cp -r geekbench.plar geekbench-workload.plar geekbench6 geekbench_${processor} ${geekbench_avx2} $out/bin

    for f in geekbench6 geekbench_${processor} ${geekbench_avx2} ; do
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
    mainProgram = "geekbench6";
  };
}
