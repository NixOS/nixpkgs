{ stdenv, fetchurl, makeWrapper, ocl-icd, vulkan-loader, linuxPackages }:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "5.3.0";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "0g7yj2a3cddaaa0n38zjqq79w5xs3sqa9zwqn2ffr2wr6y80754i";
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
      wrapProgram $out/bin/$f --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}:$out/lib/"
    done
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
