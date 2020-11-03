{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, future
, imageio
, numpy
, pandas
, pytorch
, tensorflow-tensorboard
}:

buildPythonPackage rec {
  pname = "test-tube";
  version = "0.7.5";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "williamFalcon";
    repo = pname;
    rev = version;
    sha256 = "0zpvlp1ybp2dhgap8jsalpfdyg8ycjhlfi3xrdf5dqffqvh2yhp2";
  };

  checkInputs = [
    pytestCheckHook
  ];

  requiredPythonModules = [
    future
    imageio
    numpy
    pandas
    pytorch
    tensorflow-tensorboard
  ];

  meta = with lib; {
    homepage = "https://github.com/williamFalcon/test-tube";
    description = "Framework-agnostic library to track and parallelize hyperparameter search in machine learning experiments";
    license = licenses.mit;
    maintainers = [ maintainers.tbenst ];
  };
}
