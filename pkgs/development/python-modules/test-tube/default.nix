{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pandas
, imageio
, tensorflow-tensorboard
, pytorch
, future
, tensorflow
}:

buildPythonPackage rec {
  pname = "test-tube";
  version = "0.7.5";

  disabled = !isPy3k; # requires python version >=3.6

  src = fetchFromGitHub {
    owner = "williamFalcon";
    repo = pname;
    rev = version;
    sha256 = "0zpvlp1ybp2dhgap8jsalpfdyg8ycjhlfi3xrdf5dqffqvh2yhp2";
  };

  doCheck = false;
  checkInputs = [
      tensorflow
  ];

  propagatedBuildInputs = [
    pandas
    imageio
    tensorflow-tensorboard
    pytorch
    future
  ];

  meta = with lib; {
    description = "PyTorch Lightning is the lightweight PyTorch wrapper for ML researchers. Scale your models. Write less boilerplate";
    homepage = https://github.com/williamFalcon/pytorch-lightning;
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}