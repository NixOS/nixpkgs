{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, pkg-config
, ninja
, pybind11
, torch
, cudaSupport ? false
, cudaPackages
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "v${version}";
    hash = "sha256-qrDWFY+6eVV9prUzUzb5yzyFYtEvaSyEW0zeKqAg2Vk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'print(" --- Initializing submodules")' "return" \
      --replace "_fetch_archives(_parse_sources())" "pass"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];
  buildInputs = [
    pybind11
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudnn
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
