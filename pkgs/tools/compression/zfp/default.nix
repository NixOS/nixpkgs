{ cmake, cudatoolkit, fetchFromGitHub, gfortran, lib, llvmPackages, python3Packages, stdenv, targetPlatform
, enableCfp ? true
, enableCuda ? false
, enableExamples ? true
, enableFortran ? builtins.elem targetPlatform.system gfortran.meta.platforms
, enableOpenMP ? true
, enablePython ? true
, enableUtilities ? true }:

stdenv.mkDerivation rec {
  pname = "zfp";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "zfp";
    rev = version;
    sha256 = "19ycflz35qsrzfcvxdyy0mgbykfghfi9y5v684jb4awjp7nf562c";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional enableCuda cudatoolkit
    ++ lib.optional enableFortran gfortran
    ++ lib.optional enableOpenMP llvmPackages.openmp
    ++ lib.optionals enablePython (with python3Packages; [ cython numpy python ]);

  cmakeFlags = [
    # More tests not enabled by default
    ''-DZFP_BINARY_DIR=${placeholder "out"}''
    ''-DZFP_BUILD_TESTING_LARGE=ON''
  ]
    ++ lib.optionals targetPlatform.isDarwin [
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    ]
    ++ lib.optional enableCfp "-DBUILD_CFP=ON"
    ++ lib.optional enableCuda "-DZFP_WITH_CUDA=ON"
    ++ lib.optional enableExamples "-DBUILD_EXAMPLES=ON"
    ++ lib.optional enableFortran "-DBUILD_ZFORP=ON"
    ++ lib.optional enableOpenMP "-DZFP_WITH_OPENMP=ON"
    ++ lib.optional enablePython "-DBUILD_ZFPY=ON"
    ++ ([ "-DBUILD_UTILITIES=${if enableUtilities then "ON" else "OFF"}" ]);

  preCheck = lib.optional targetPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="$out/lib:$DYLD_LIBRARY_PATH"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://computing.llnl.gov/projects/zfp";
    description = "Library for random-access compression of floating-point arrays";
    license = licenses.bsd3;
    maintainers = with maintainers; [ spease atila ];
    # 64-bit only
    platforms = platforms.aarch64 ++ platforms.x86_64;
  };
}
