{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, symlinkJoin
, ffmpeg-full
, pkg-config
, ninja
, pybind11
, sox
, torch
, cudaSupport ? torch.cudaSupport
, cudaPackages
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "refs/tags/v${version}";
    hash = "sha256-8EPoZ/dfxrQjdtE0rZ+2pOaXxlyhRuweYnVuA9i0Fgc=";
  };

  patches = [
    ./0001-setup.py-propagate-cmakeFlags.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'print(" --- Initializing submodules")' "return" \
      --replace "_fetch_archives(_parse_sources())" "pass"
  '';

  env = {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
  };

  # https://github.com/pytorch/audio/blob/v2.1.0/docs/source/build.linux.rst#optional-build-torchaudio-with-a-custom-built-ffmpeg
  FFMPEG_ROOT = symlinkJoin {
    name = "ffmpeg";
    paths = [
      ffmpeg-full.bin
      ffmpeg-full.dev
      ffmpeg-full.lib
    ];
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    ffmpeg-full
    pybind11
    sox
    torch.cxxdev
  ];

  propagatedBuildInputs = [
    torch
  ];

  BUILD_SOX=0;
  BUILD_KALDI=0;
  BUILD_RNNT=0;
  BUILD_CTC_DECODER=0;

  dontUseCmakeConfigure = true;

  doCheck = false; # requires sox backend

  meta = with lib; {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    license = licenses.bsd2;
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
