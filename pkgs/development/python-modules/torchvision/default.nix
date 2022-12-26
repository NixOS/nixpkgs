{ lib
, symlinkJoin
, buildPythonPackage
, fetchFromGitHub
, ninja
, which
, libjpeg_turbo
, libpng
, numpy
, scipy
, pillow
, torch
, pytest
, cudaSupport ? torch.cudaSupport or false # by default uses the value from torch
}:

let
  inherit (torch.cudaPackages) cudatoolkit cudaFlags cudnn;

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };
  cudaArchStr = lib.optionalString cudaSupport lib.strings.concatStringsSep ";" torch.cudaArchList;
in buildPythonPackage rec {
  pname = "torchvision";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "refs/tags/v${version}";
    hash = "sha256-lKkEJolJQaLr1TVm44CizbJQedGa1wyy0cFWg2LTJN0=";
  };

  nativeBuildInputs = [ libpng ninja which ]
    ++ lib.optionals cudaSupport [ cudatoolkit_joined ];

  TORCHVISION_INCLUDE = "${libjpeg_turbo.dev}/include/";
  TORCHVISION_LIBRARY = "${libjpeg_turbo}/lib/";

  buildInputs = [ libjpeg_turbo libpng ]
    ++ lib.optionals cudaSupport [ cudnn ];

  propagatedBuildInputs = [ numpy pillow torch scipy ];

  preBuild = lib.optionalString cudaSupport ''
    export TORCH_CUDA_ARCH_LIST="${cudaFlags.cudaCapabilitiesSemiColonString}"
    export FORCE_CUDA=1
  '';

  # tries to download many datasets for tests
  doCheck = false;

  checkPhase = ''
    HOME=$TMPDIR py.test test --ignore=test/test_datasets_download.py
  '';

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
