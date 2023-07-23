{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, ocl-icd, hwloc, zlib, mkl, intel-oneapi-compiler }:

stdenv.mkDerivation rec {
  pname = "intel-ocl";
  version = "2023.1.0";

  # Refer https://aur.archlinux.org/packages/intel-cpu-runtime
  src = fetchurl {
    url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-runtime-opencl-2023.1.0-46305_amd64.deb";
    hash = "sha256-/nR9WIgjwlXxKZcAKfNuP082Jz25a8zlf5SQwDEBnYg=";
  };

  buildInputs = [
    dpkg
    autoPatchelfHook
  ];

  nativeBuildInputs = [
    stdenv.cc.cc.lib
    ocl-icd
    hwloc
    zlib
    mkl
    intel-oneapi-compiler
  ];

  # replace opt/intel/oneapi/lib/etc/intel64.icd by a new icd file
  # ocl-icd will provide lib/libOpenCL.so*
  installPhase = ''
    install -d $out/lib
    cp -r opt/intel/oneapi/lib/intel64 -t $out/lib
    install -Dm644 opt/intel/oneapi/lib/clbltfnshared.rtl -t $out/lib
    install -d $out/etc/OpenCL/vendors
    echo "$out/lib/intel64/libintelocl.so" > $out/etc/OpenCL/vendors/intel64.icd
  '';

  dontStrip = true;

  meta = {
    description = "Official OpenCL runtime for Intel CPUs";
    homepage = "https://software.intel.com/en-us/articles/opencl-drivers";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.kierdavis ];
  };
}
