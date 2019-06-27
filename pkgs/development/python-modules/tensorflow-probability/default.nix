{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, tensorflow
, decorator
, cloudpickle
, hypothesis
, scipy
, matplotlib
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "tensorflow-probability";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "probability";
    rev = "v${version}";
    sha256 = "0sy9gmjcvmwciamqvd7kd9qw2wd7ksklk80815fsn7sj0wiqxjyd";
  };

  propagatedBuildInputs = [
    tensorflow
    decorator
    cloudpickle
  ];

  # Listed here:
  # https://github.com/tensorflow/probability/blob/f01d27a6f256430f03b14beb14d37def726cb257/testing/run_tests.sh#L58
  checkInputs = [
    hypothesis
    pytest
    scipy
    matplotlib
    mock
  ];

  # actual checks currently fail because for some reason
  # tf.enable_eager_execution is called too late. Probably because upstream
  # intents these tests to be run by bazel, not plain pytest.
  # checkPhase = ''
  #   # tests need to import from other test files
  #   export PYTHONPATH="$PWD/tensorflow-probability:$PYTHONPATH"
  #   py.test
  # '';

  # sanity check
  checkPhase = ''
    python -c 'import tensorflow_probability'
  '';

  meta = with lib; {
    description = "Library for probabilistic reasoning and statistical analysis";
    homepage = https://www.tensorflow.org/probability/;
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
