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
, pytorch
, pytest
, cudatoolkit
, cudnn
, cudaSupport ? null  # by default uses the value from pytorch
}:

let
  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };
  final_cudaSupport = if cudaSupport == null then pytorch.cudaSupport else cudaSupport;
  cudaArchStr = if final_cudaSupport then lib.strings.concatStringsSep ";" pytorch.cudaArchList else "";
in buildPythonPackage rec {
  pname = "torchvision";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "v${version}";
    sha256 = "13j04ij0jmi58nhav1p69xrm8dg7jisg23268i3n6lnms37n02kc";
  };

  nativeBuildInputs = [ libpng ninja which ] ++ lib.optional final_cudaSupport [ cudatoolkit_joined ];

  TORCHVISION_INCLUDE = "${libjpeg_turbo.dev}/include/";
  TORCHVISION_LIBRARY = "${libjpeg_turbo}/lib/";

  buildInputs = [ libjpeg_turbo libpng ] ++ lib.optional final_cudaSupport [ cudnn ];

  propagatedBuildInputs = [ numpy pillow pytorch scipy ];

  preBuild = if final_cudaSupport then ''
    export TORCH_CUDA_ARCH_LIST="${cudaArchStr}"
    export FORCE_CUDA=1
  '' else "";

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
    platforms = with platforms; linux ++ lib.optionals (!final_cudaSupport) darwin;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
