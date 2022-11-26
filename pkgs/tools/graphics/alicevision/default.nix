{ lib
, config
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, icu
, boost
, llvmPackages
, ceres-solver
, openexr
, opencv
, flann
, eigen
, openimageio2
, geogram
, doxygen
, coin-utils
, coin-clp
, coin-osi
, assimp
, tbb
, metis
, opengv
, pcl
## Need to combine all outputs/library files into dev
## for alembic
, alembic
, apriltag
, popsift
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, python3
, wget
}:

stdenv.mkDerivation rec {
  pname = "alicevision";
  version = "2022-10-15";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "672fb43cea53bbf07b262f0e3ee618c62aec2f9b";
    deepClone = true;
    fetchSubmodules = true;
    sha256 = "DDvHpqSIt6fbH1tufP21iVxtJl6CNE1ppZ2KMDn4t8c=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    icu
    boost
    llvmPackages.openmp
    ceres-solver
    openexr
    ## OpenCV Sift is unfree, and
    ## if using unfree, use CUDA based SIFT
    ## Maybe I'll add the option soon
    ## though it's a commerical license
    ## for research purposes only
    opencv
    flann
    eigen
    openimageio2
    geogram
    doxygen
    coin-utils
    coin-clp
    coin-osi
    assimp
    alembic
    apriltag
    tbb
    metis
    opengv
  ] ++ lib.optional cudaSupport [
    cudatoolkit
    popsift
  ];
  hardeningDisable = [
    "all"
  ];
  EIGEN_ROOT_DIR = "${eigen}/";
  cmakeFlags = [
    "-DALICEVISION_USE_OPENCV=ON"
    "-DALICEVISION_USE_CUDA=${if cudaSupport then "ON" else "OFF"}"
  ];
}
