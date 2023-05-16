{ lib
, stdenv
, openblas
, blas
, lapack
<<<<<<< HEAD
=======
, openfst
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, icu
, cmake
, pkg-config
, fetchFromGitHub
<<<<<<< HEAD
, python3
, Accelerate
, _experimental-update-script-combinators
, common-updater-scripts
, ripgrep
, unstableGitUpdater
, writeShellScript
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";
stdenv.mkDerivation (finalAttrs: {
  pname = "kaldi";
  version = "unstable-2023-05-02";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kaldi-asr";
    repo = "kaldi";
<<<<<<< HEAD
    rev = "71f38e62cad01c3078555bfe78d0f3a527422d75";
    sha256 = "sha256-2xm0F80cjovy/G9Ytq/iwa1eexZk0mromv6PPuNIT8U=";
=======
    rev = "f6f4ccaf213f0fe8b26e633a7dc0c802150626a0";
    sha256 = "sha256-ybW2J4lWf6YaQGZZvxEVDUMAg84DC17W+yX6ZsuBDac=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cmakeFlags = [
    "-DKALDI_BUILD_TEST=off"
    "-DBUILD_SHARED_LIBS=on"
    "-DBLAS_LIBRARIES=-lblas"
    "-DLAPACK_LIBRARIES=-llapack"
<<<<<<< HEAD
    "-DFETCHCONTENT_SOURCE_DIR_OPENFST:PATH=${finalAttrs.passthru.sources.openfst}"
  ];

  buildInputs = [
    openblas
=======
  ];

  enableParallelBuilding = true;

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

  outputs = [ "out" "dev" ];

  buildInputs = [
    openblas
    openfst
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    icu
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

<<<<<<< HEAD
  preConfigure = ''
    cmakeFlagsArray+=(
      # Extract version without the need for git.
      # https://github.com/kaldi-asr/kaldi/blob/71f38e62cad01c3078555bfe78d0f3a527422d75/cmake/VersionHelper.cmake
      # Patch number is not actually used by default so we can just ignore it.
      # https://github.com/kaldi-asr/kaldi/blob/71f38e62cad01c3078555bfe78d0f3a527422d75/CMakeLists.txt#L214
      "-DKALDI_VERSION=$(cat src/.version)"
    )
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    mkdir -p $out/share/kaldi
    cp -r ../egs $out/share/kaldi
  '';

<<<<<<< HEAD
  passthru = {
    sources = {
      # rev from https://github.com/kaldi-asr/kaldi/blob/master/cmake/third_party/openfst.cmake
      openfst = fetchFromGitHub {
        owner = "kkm000";
        repo = "openfst";
        rev = "338225416178ac36b8002d70387f5556e44c8d05";
        hash = "sha256-MGEUuw7ex+WcujVdxpO2Bf5sB6Z0edcAeLGqW/Lo1Hs=";
      };
    };

    updateScript =
      let
        updateSource = unstableGitUpdater {};
        updateOpenfst = writeShellScript "update-openfst" ''
          hash=$(${ripgrep}/bin/rg --multiline --pcre2 --only-matching 'FetchContent_Declare\(\s*openfst[^)]*GIT_TAG\s*([0-9a-f]{40})' --replace '$1' "${finalAttrs.src}/cmake/third_party/openfst.cmake")
          ${common-updater-scripts}/bin/update-source-version kaldi.sources.openfst "$hash" --source-key=out "--version-key=rev"
        '';
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateOpenfst
      ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Speech Recognition Toolkit";
    homepage = "https://kaldi-asr.org";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
