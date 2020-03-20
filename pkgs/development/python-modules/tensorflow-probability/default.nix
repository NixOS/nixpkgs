{ lib
, fetchFromGitHub
, buildBazelPackage
, buildPythonPackage
, python
, setuptools
, wheel
, tensorflow
, six
, numpy
, decorator
, cloudpickle
, hypothesis
, scipy
, matplotlib
, mock
, pytest
}:

let
  version = "0.7";
  pname = "tensorflow_probability";

  # first build all binaries and generate setup.py using bazel
  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py2.py3-none-any.whl";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "probability";
      rev = "v${version}";
      sha256 = "0sy9gmjcvmwciamqvd7kd9qw2wd7ksklk80815fsn7sj0wiqxjyd";
    };

    nativeBuildInputs = [
      # needed to create the output wheel in installPhase
      python
      setuptools
      wheel
    ];

    bazelTarget = ":pip_pkg";

    fetchAttrs = {
      sha256 = "0135nxxvkmjzpd80r1g9fdkk9h62g0xlvp32g5zgk0hkma5kq0bx";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';

      installPhase = ''
        # work around timestamp issues
        # https://github.com/NixOS/nixpkgs/issues/270#issuecomment-467583872
        export SOURCE_DATE_EPOCH=315532800

        # First build, then move. Otherwise pip_pkg would create the dir $out
        # and then put the wheel in that directory. However we want $out to
        # point directly to the wheel file.
        ./bazel-bin/pip_pkg . --release
        mv *.whl "$out"
      '';
    };
  };
in buildPythonPackage {
  inherit version pname;
  format = "wheel";

  src = bazel-wheel;

  propagatedBuildInputs = [
    tensorflow
    six
    numpy
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
