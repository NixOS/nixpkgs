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
  version = "0.628";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "williamFalcon";
    repo = pname;
    rev = version;
    sha256 = "0w60xarmcw06gc4002sy7bjfykdz34gbgniswxkl0lw8a1v0xn2m";
  };

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
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
