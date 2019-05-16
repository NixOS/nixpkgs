{ lib
, fetchFromGitHub
, buildPythonPackage
, tensorflow
, pytest
}:

buildPythonPackage rec {
  pname = "tensorflow-probability";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "probability";
    rev = "v${version}";
    sha256 = "1y210n4asv8j39pk68bdfrz01gddflvzhxbcvj5jw6rjgaagnhvx";
  };

  propagatedBuildInputs = [
    tensorflow
  ];

  checkInputs = [
    pytest
  ];

  # Tests have an invalid import (`tensorflow_probability.opensource`), should
  # be resolved in the next version with
  # https://github.com/tensorflow/probability/commit/77d5957f2f0bdddcb46582799cd9c5c5167a1a40
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Library for probabilistic reasoning and statistical analysis";
    homepage = https://www.tensorflow.org/probability/;
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
