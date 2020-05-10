{ buildPythonPackage
, isPy3k
, fetchFromGitHub
, python
, which
, six
, numpy
, pillow
, pytorch
, lib
, enableCUDA ? false
, cudatoolkit ? null
}:

buildPythonPackage rec {
  pname = "torchvision";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    rev = "v${version}";
    sha256 = "1q4mik66scnqfdvyi46h5py27jk6dx5vkb3g6kz7d0xbcjv9866m";
  };

  # manually check compatibility
  PYTORCH_VERSION = pytorch.version;
  nativeBuildInputs = [ which ]
    ++ lib.optionals enableCUDA [ cudatoolkit ];
  propagatedBuildInputs = [ six numpy pillow pytorch ];

  meta = {
    description = "PyTorch vision library";
    homepage    = "https://pytorch.org/";
    license     = lib.licenses.bsd3;
    platforms   = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
