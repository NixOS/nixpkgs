{ lib, stdenv, fetchurl, makeWrapper, ocl-icd, vulkan-loader, linuxPackages }:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "5.4.6";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "sha256-fCS6cSD3w2EbLL1yNfH+NKxswRUY4zyCR07gKGXW4Yc=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r geekbench.plar geekbench5 geekbench_x86_64 $out/bin

    # needed for compute benchmark
    ln -s ${linuxPackages.nvidia_x11}/lib/libcuda.so $out/lib/
    ln -s ${ocl-icd}/lib/libOpenCL.so $out/lib/
    ln -s ${ocl-icd}/lib/libOpenCL.so.1 $out/lib/
    ln -s ${vulkan-loader}/lib/libvulkan.so $out/lib/
    ln -s ${vulkan-loader}/lib/libvulkan.so.1 $out/lib/

    for f in geekbench5 geekbench_x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/$f
      wrapProgram $out/bin/$f --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}:$out/lib/"
    done
  '';

  meta = with lib; {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
