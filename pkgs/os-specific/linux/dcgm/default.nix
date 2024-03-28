{ lib
, gcc11Stdenv
, fetchFromGitHub
, catch2
, cmake
, cudaPackages_10_2
, cudaPackages_11_8
, cudaPackages_12
, fmt_9
, git
, jsoncpp
, libevent
, plog
, python3
, symlinkJoin
, tclap_1_4
, yaml-cpp
}:
let
  # Flags copied from DCGM's libevent build script
  libevent-nossl = libevent.override { sslSupport = false; };
  libevent-nossl-static = libevent-nossl.overrideAttrs (super: {
    CFLAGS = "-Wno-cast-function-type -Wno-implicit-fallthrough -fPIC";
    CXXFLAGS = "-Wno-cast-function-type -Wno-implicit-fallthrough -fPIC";
    configureFlags = super.configureFlags ++ [ "--disable-shared" "--with-pic" ];
  });

  jsoncpp-static = jsoncpp.override { enableStatic = true; };

  # DCGM depends on 3 different versions of CUDA at the same time.
  # The runtime closure, thankfully, is quite small because most things
  # are statically linked.
  cudaPackageSetByVersion = [
    {
      version = "10";
      # Nixpkgs cudaPackages_10 doesn't have redist packages broken out.
      pkgSet = [
        cudaPackages_10_2.cudatoolkit
        cudaPackages_10_2.cudatoolkit.lib
      ];
    }
    {
      version = "11";
      pkgSet = getCudaPackages cudaPackages_11_8;
    }
    {
      version = "12";
      pkgSet = getCudaPackages cudaPackages_12;
    }
  ];

  # Select needed redist packages from cudaPackages
  # C.f. https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/dcgmbuild/scripts/0080_cuda.sh#L24-L39
  getCudaPackages = p: with p; [
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cuda_nvml_dev
    libcublas
    libcufft
    libcurand
  ];

  # Builds CMake code to add CUDA paths for include and lib.
  mkAppendCudaPaths = { version, pkgSet }:
    let
      # The DCGM CMake assumes that the folder containing cuda.h contains all headers, so we must
      # combine everything together for headers to work.
      # It would be more convenient to use symlinkJoin on *just* the include subdirectories
      # of each package, but not all of them have an include directory and making that work
      # is more effort than it's worth for this temporary, build-time package.
      combined = symlinkJoin {
        name = "cuda-combined-${version}";
        paths = pkgSet;
      };
      # The combined package above breaks the build for some reason so we just configure
      # each package's library path.
      libs = lib.concatMapStringsSep " " (x: ''"${x}/lib"'') pkgSet;
    in ''
      list(APPEND Cuda${version}_INCLUDE_PATHS "${combined}/include")
      list(APPEND Cuda${version}_LIB_PATHS ${libs})
    '';

# gcc11 is required by DCGM's very particular build system
# C.f. https://github.com/NVIDIA/DCGM/blob/7e1012302679e4bb7496483b32dcffb56e528c92/dcgmbuild/build.sh#L22
in gcc11Stdenv.mkDerivation rec {
  pname = "dcgm";
  version = "3.2.5"; # N.B: If you change this, be sure prometheus-dcgm-exporter supports this version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DCGM";
    rev = "refs/tags/v${version}";
    hash = "sha256-iMyYOr3dSpdRV2S/TlB/tEOAWYhK09373ZRbd5vzogQ=";
  };

  # Add our paths to the CUDA paths so FindCuda.cmake can find them.
  EXTRA_CUDA_PATHS = lib.concatMapStringsSep "\n" mkAppendCudaPaths cudaPackageSetByVersion;
  prePatch = ''
    echo "$EXTRA_CUDA_PATHS"$'\n'"$(cat cmake/FindCuda.cmake)" > cmake/FindCuda.cmake
  '';

  hardeningDisable = [ "all" ];

  strictDeps = true;

  nativeBuildInputs = [
    # autoAddDriverRunpath does not actually depend on or incur any dependency
    # of cudaPackages. It merely adds an impure, non-Nix PATH to the RPATHs of
    # executables that need to use cuda at runtime.
    cudaPackages_12.autoAddDriverRunpath

    cmake
    git
    python3
  ];

  buildInputs = [
    plog.dev # header-only
    tclap_1_4 # header-only

    catch2
    fmt_9
    jsoncpp-static
    libevent-nossl-static
    yaml-cpp
  ];

  disallowedReferences = lib.concatMap (x: x.pkgSet) cudaPackageSetByVersion;

  meta = with lib; {
    description = "Data Center GPU Manager (DCGM) is a daemon that allows users to monitor NVIDIA data-center GPUs.";
    homepage = "https://developer.nvidia.com/dcgm";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
    mainProgram = "dcgmi";
    platforms = platforms.linux;
  };
}
