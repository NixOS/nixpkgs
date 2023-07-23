{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, level-zero, tbb_2021_8, libffi_3_3, zlib, ocl-icd }:

stdenv.mkDerivation rec {
  pname = "intel-oneapi-compiler";
  version = "2023.1.0";

  # Refer:
  # - https://archlinux.org/packages/extra/x86_64/intel-oneapi-compiler-shared-runtime
  # - https://archlinux.org/packages/extra/x86_64/intel-oneapi-compiler-dpcpp-cpp-runtime
  # intel-oneapi-compiler-shared-runtime has some files which need libsycl.so provided by intel-oneapi-compiler-dpcpp-cpp-runtime
  # intel-oneapi-compiler-dpcpp-cpp-runtime has some files which need many libraries provided by intel-oneapi-compiler-shared-runtime
  # so they are packaged together
  srcs = [
    (fetchurl {
      url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-dpcpp-cpp-runtime-2023.1.0-2023.1.0-46305_amd64.deb";
      hash = "sha256-0O7Gf+fjs2yMWx0HoXd59zn9L9GIH2sYSBafr/y4VcY=";
    })
    (fetchurl {
      url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-dpcpp-cpp-common-2023.1.0-2023.1.0-46305_all.deb";
      hash = "sha256-nBF7Jd3uaZ0agWKrEBucI77upemj8kCUFO5rvHjWWTs=";
    })
    (fetchurl {
      url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-shared-runtime-2023.1.0-2023.1.0-46305_amd64.deb";
      hash = "sha256-+j9MI/Un8c7XZ/71bAIuJS2u3Qj6t1LsZTmF8XjVCbY=";
    })
    (fetchurl {
      url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-shared-common-2023.1.0-2023.1.0-46305_all.deb";
      hash = "sha256-iU6vE7/oQNL130loXp9bucqCErwsjd+Eityrs4BtuL0=";
    })
  ];

  buildInputs = [
    dpkg
    autoPatchelfHook
  ];

  nativeBuildInputs = [
    stdenv.cc.cc.lib
    level-zero
    tbb_2021_8
    libffi_3_3
    zlib
    ocl-icd
  ];

  # llvm will provide lib/clang
  # ocl-icd will provide lib/libOpenCL.so*
  # ignore eclipse plugins
  installPhase = ''
    install -Dm644 opt/intel/oneapi/compiler/2023.1.0/documentation/en/man/common/man1/dpcpp.1 -t $out/share/man/man1
    install -d $out/share/cmake
    cp -r opt/intel/oneapi/compiler/2023.1.0/linux/{doc,IntelDPCPP,IntelSYCL} $out/share/cmake
    install -d $out/include
    cp -r opt/intel/oneapi/compiler/2023.1.0/linux/{include,compiler/{include,perf_headers/c++}}/* $out/include
    install -D opt/intel/oneapi/compiler/2023.1.0/linux/bin/* -t $out/bin
    cp -r opt/intel/oneapi/compiler/2023.1.0/linux/lib $out
    install -Dm644 opt/intel/oneapi/compiler/2023.1.0/linux/compiler/lib/intel64_lin/* -t $out/lib
    rm -r $out/lib/clang $out/lib/libOpenCL.so*
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Intel oneAPI compiler runtime libraries";
    homepage = "https://software.intel.com/en-us/articles/opencl-drivers";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Freed-Wu ];
  };
}
