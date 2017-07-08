{ stdenv, fetchzip, rpmextract, ncurses5, numactl, zlib }:

stdenv.mkDerivation rec {
  version = "r4.0-59481";
  name = "intel-ocl-${version}";

  src = fetchzip {
    url = "https://software.intel.com/sites/default/files/managed/48/96/SRB4_linux64.zip";
    sha256 = "1q69g28i6l7p13hnsk82g2qhdf2chwh4f0wvzac6xml67hna3v34";
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
    rpmextract SRB4_linux64.zip/intel-opencl-${version}.x86_64.rpm
    rpmextract SRB4_linux64.zip/intel-opencl-cpu-${version}.x86_64.rpm
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
