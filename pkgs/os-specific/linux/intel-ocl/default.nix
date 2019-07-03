{ stdenv, fetchzip, rpmextract, ncurses5, numactl, zlib }:

stdenv.mkDerivation rec {
  name = "intel-ocl-${version}";
  version = "5.0-63503";

  src = fetchzip {
    url = "https://registrationcenter-download.intel.com/akdlm/irc_nas/11396/SRB5.0_linux64.zip";
    sha256 = "0qbp63l74s0i80ysh9ya8x7r79xkddbbz4378nms9i7a0kprg9p2";
    stripRoot = false;
  };

  buildInputs = [ rpmextract ];

  sourceRoot = ".";

  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    ncurses5
    numactl
    zlib
  ];

  postUnpack = ''
    # Extract the RPMs contained within the source ZIP.
    rpmextract source/intel-opencl-r${version}.x86_64.rpm
    rpmextract source/intel-opencl-cpu-r${version}.x86_64.rpm
  '';

  patchPhase = ''
    runHook prePatch

    # Remove libOpenCL.so, since we use ocl-icd's libOpenCL.so instead and this would cause a clash.
    rm opt/intel/opencl/libOpenCL.so*

    # Patch shared libraries.
    for lib in opt/intel/opencl/*.so; do
      patchelf --set-rpath "${libPath}:$out/lib/intel-ocl" $lib || true
    done

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    # Create ICD file, which just contains the path of the corresponding shared library.
    echo "$out/lib/intel-ocl/libintelocl.so" > intel.icd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 0755 opt/intel/opencl/*.so* -t $out/lib/intel-ocl
    install -D -m 0644 opt/intel/opencl/*.{o,rtl,bin} -t $out/lib/intel-ocl
    install -D -m 0644 opt/intel/opencl/{LICENSE,NOTICES} -t $out/share/doc/intel-ocl
    install -D -m 0644 intel.icd -t $out/etc/OpenCL/vendors

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Official OpenCL runtime for Intel CPUs";
    homepage    = https://software.intel.com/en-us/articles/opencl-drivers;
    license     = stdenv.lib.licenses.unfree;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.kierdavis ];
  };
}
