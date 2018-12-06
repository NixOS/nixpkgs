{ stdenv, fetchFromGitHub
, cmake, pkgconfig, flex, bison
, llvmPackages, kernel, linuxHeaders, elfutils, libelf, bcc
}:

stdenv.mkDerivation rec {
  name = "bpftrace-unstable-${version}";
  version = "2018-10-27";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "bpftrace";
    rev = "c07b54f61fd7b7b49e0a254e746d6f442c5d780d";
    sha256 = "1mpcjfyay9akmpqxag2ndwpz1qsdx8ii07jh9fky4w40wi9cipyg";
  };

  # bpftrace requires an unreleased version of bcc, added to the cmake
  # build as an ExternalProject.
  # https://github.com/iovisor/bpftrace/issues/184
  bccSrc = fetchFromGitHub {
    owner = "iovisor";
    repo = "bcc";
    rev = "afd00154865f3b2da6781cf92cecebaca4853950";
    sha256 = "0ad78smrnipr1f377i5rv6ksns7v2vq54g5badbj5ldqs4x0hygd";
  };

  buildInputs = [
    llvmPackages.llvm llvmPackages.clang-unwrapped kernel
    elfutils libelf bccSrc
  ];

  nativeBuildInputs = [ cmake pkgconfig flex bison ]
    # libelf is incompatible with elfutils-libelf
    ++ stdenv.lib.filter (x: x != libelf) kernel.moduleBuildDependencies;

  patches = [
    ./bcc-source.patch
    # https://github.com/iovisor/bpftrace/issues/184
    ./disable-gtests.patch
  ];

  configurePhase = ''
    mkdir build
    cd build
    cmake ../                                   \
      -DKERNEL_HEADERS_DIR=${linuxHeaders}      \
      -DNIX_BUILDS:BOOL=ON                      \
      -DCMAKE_INSTALL_PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage = https://github.com/iovisor/bpftrace;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
