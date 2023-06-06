{ lib
, stdenv
, openblas
, blas
, lapack
, icu
, cmake
, pkg-config
, fetchFromGitHub
, git
, python3
, Accelerate
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";
let
  # rev from https://github.com/kaldi-asr/kaldi/blob/master/cmake/third_party/openfst.cmake
  openfst = fetchFromGitHub {
    owner = "kkm000";
    repo = "openfst";
    rev = "338225416178ac36b8002d70387f5556e44c8d05";
    sha256 = "sha256-MGEUuw7ex+WcujVdxpO2Bf5sB6Z0edcAeLGqW/Lo1Hs=";
  };
in
stdenv.mkDerivation {
  pname = "kaldi";
  version = "unstable-2022-09-26";

  src = fetchFromGitHub {
    owner = "kaldi-asr";
    repo = "kaldi";
    rev = "f6f4ccaf213f0fe8b26e633a7dc0c802150626a0";
    sha256 = "sha256-ybW2J4lWf6YaQGZZvxEVDUMAg84DC17W+yX6ZsuBDac=";
  };

  cmakeFlags = [
    "-DKALDI_BUILD_TEST=off"
    "-DBUILD_SHARED_LIBS=on"
    "-DBLAS_LIBRARIES=-lblas"
    "-DLAPACK_LIBRARIES=-llapack"
    "-DFETCHCONTENT_SOURCE_DIR_OPENFST:PATH=${openfst}"
  ];

  buildInputs = [
    openblas
    icu
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  preConfigure = ''
    cmakeFlagsArray+=(
      # Extract version without the need for git.
      # https://github.com/kaldi-asr/kaldi/blob/71f38e62cad01c3078555bfe78d0f3a527422d75/cmake/VersionHelper.cmake
      # Patch number is not actually used by default so we can just ignore it.
      # https://github.com/kaldi-asr/kaldi/blob/71f38e62cad01c3078555bfe78d0f3a527422d75/CMakeLists.txt#L214
      "-DKALDI_VERSION=$(cat src/.version)"
    )
  '';

  postInstall = ''
    mkdir -p $out/share/kaldi
    cp -r ../egs $out/share/kaldi
  '';

  meta = with lib; {
    description = "Speech Recognition Toolkit";
    homepage = "https://kaldi-asr.org";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
