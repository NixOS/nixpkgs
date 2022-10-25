{ lib, stdenv
, openblas
, blas
, lapack
, openfst
, icu
, cmake
, pkg-config
, fetchFromGitHub
, git
, python3
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
  version = "2022-07-20";

  src = fetchFromGitHub {
    owner = "kaldi-asr";
    repo = "kaldi";
    rev = "9af2c5c16389e141f527ebde7ee432a0c1df9fb9";
    sha256 = "sha256-+gX9cm5iUmeuufofxB6VZpjDjPp7+Lr/bhCSRypB0cU=";
  };

  cmakeFlags = [
    "-DKALDI_BUILD_TEST=off"
    "-DBUILD_SHARED_LIBS=on"
    "-DLAPACK_LIBRARIES=-llapack"
    "-DBLAS_LIBRARIES=-lblas"
  ];

  preConfigure = ''
    mkdir bin
    cat > bin/git <<'EOF'
    #!${stdenv.shell}
    if [[ "$1" == "--version" ]]; then
      # cmake checks this
      ${git}/bin/git --version
    elif [[ "$1" == "clone" ]]; then
      # mock this call:

      # https://github.com/kaldi-asr/kaldi/blob/c9d8b9ad3fef89237ba5517617d977b7d70a7ed5/cmake/third_party/openfst.cmake#L5
      cp -r ${openfst} ''${@: -1}
      chmod -R +w ''${@: -1}
    elif [[ "$1" == "rev-list" ]]; then
      # fix up this call:
      # https://github.com/kaldi-asr/kaldi/blob/c9d8b9ad3fef89237ba5517617d977b7d70a7ed5/cmake/VersionHelper.cmake#L8
      echo 0
    elif [[ "$1" == "rev-parse" ]]; then
      echo ${openfst.rev}
      echo 0
    fi
    true
    EOF
    chmod +x bin/git
    export PATH=$(pwd)/bin:$PATH
  '';

  buildInputs = [
    openblas
    openfst
    icu
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  postInstall = ''
    mkdir -p $out/share/kaldi
    cp -r ../egs $out/share/kaldi
  '';

  meta = with lib; {
    description = "Speech Recognition Toolkit";
    homepage = "https://kaldi-asr.org";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
