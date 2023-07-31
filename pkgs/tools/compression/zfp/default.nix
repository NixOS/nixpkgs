{ cmake, cudatoolkit, fetchFromGitHub, gfortran, lib, llvmPackages, python3Packages, stdenv
, config
, enableCfp ? true
, enableCuda ? config.cudaSupport
, enableFortran ? builtins.elem stdenv.targetPlatform.system gfortran.meta.platforms
, enableOpenMP ? true
, enablePython ? true
, enableUtilities ? true }:

stdenv.mkDerivation rec {
  pname = "zfp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "zfp";
    rev = version;
    sha256 = "sha256-E2LI1rWo1HO5O/sxPHAmLDs3Z5xouzlgMj11rQFPNYQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional enableCuda cudatoolkit
    ++ lib.optional enableFortran gfortran
    ++ lib.optional enableOpenMP llvmPackages.openmp
    ++ lib.optionals enablePython (with python3Packages; [ cython numpy python ]);

  # compile CUDA code for all extant GPUs so the binary will work with any GPU
  # and driver combination. to be ultimately solved upstream:
  # https://github.com/LLNL/zfp/issues/178
  # NB: not in cmakeFlags due to https://github.com/NixOS/nixpkgs/issues/114044
  preConfigure = lib.optionalString enableCuda ''
    cmakeFlagsArray+=(
      "-DCMAKE_CUDA_FLAGS=-gencode=arch=compute_52,code=sm_52 -gencode=arch=compute_60,code=sm_60 -gencode=arch=compute_61,code=sm_61 -gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_80,code=sm_80 -gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_87,code=sm_87 -gencode=arch=compute_86,code=compute_86"
    )
  '';

  cmakeFlags = [
  ] ++ lib.optional enableCfp "-DBUILD_CFP=ON"
    ++ lib.optional enableCuda "-DZFP_WITH_CUDA=ON"
    ++ lib.optional enableFortran "-DBUILD_ZFORP=ON"
    ++ lib.optional enableOpenMP "-DZFP_WITH_OPENMP=ON"
    ++ lib.optional enablePython "-DBUILD_ZFPY=ON"
    ++ ([ "-DBUILD_UTILITIES=${if enableUtilities then "ON" else "OFF"}" ]);

  doCheck = true;

  meta = with lib; {
    homepage = "https://computing.llnl.gov/projects/zfp";
    description = "Library for random-access compression of floating-point arrays";
    license = licenses.bsd3;
    maintainers = [ maintainers.spease ];
    # 64-bit only
    platforms = platforms.aarch64 ++ platforms.x86_64;
  };
}
