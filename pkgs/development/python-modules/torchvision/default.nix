{ stdenv
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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "torchvision";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "v${version}";
    sha256 = "0yhpbq7linrk2qp5jxsvlgkmwa5bn38s9kcswy4jzvmx1fjbkpq0";
  };

  nativeBuildInputs = [ libpng ninja which ];

  TORCHVISION_INCLUDE="${libjpeg_turbo.dev}/include/";
  TORCHVISION_LIBRARY="${libjpeg_turbo}/lib/";

  buildInputs = [ libjpeg_turbo libpng ];

  propagatedBuildInputs = [ numpy pillow pytorch scipy ];

  # checks fail to import _C.so and various other failures
  doCheck = false;

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "--ignore=test/test_datasets_download.py" ];

  meta = with stdenv.lib; {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ericsagnes SuperSandro2000 ];
  };
}
