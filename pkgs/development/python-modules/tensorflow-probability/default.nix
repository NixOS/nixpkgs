{ lib
, fetchFromGitHub
, fetchpatch
, bazel_0_26
, buildBazelPackage
, buildPythonPackage
, python
, setuptools
, wheel
, absl-py
, tensorflow
, six
, numpy
, decorator
, cloudpickle
, gast
, hypothesis
, scipy
, matplotlib
, mock
, pytest
}:

let
  version = "0.8.0";
  pname = "tensorflow_probability";

  # first build all binaries and generate setup.py using bazel
  bazel-wheel = buildBazelPackage {
    bazel = bazel_0_26;

    name = "${pname}-${version}-py2.py3-none-any.whl";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "probability";
      rev = version;
      sha256 = "07cm8zba8n0ihzdm3k4a4rsg5v62xxsfvcw4h0niz91c0parqjqy";
    };

    patches = [
      (fetchpatch {
        name = "gast-0.3.patch";
        url = "https://github.com/tensorflow/probability/commit/ae7a9d9771771ec1e7755a3588b9325f050a84cc.patch";
        sha256 = "0kfhx30gshm8f3945na9yjjik71r20qmjzifbigaj4l8dwd9dz1a";
        excludes = ["testing/*"];
      })
      (fetchpatch {
        name = "cloudpickle-1.2.patch";
        url = "https://github.com/tensorflow/probability/commit/78ef12b5afe3f567d16c70b74015ed1ddff1b0c8.patch";
        sha256 = "12ms2xcljvvrnig0j78s3wfv4yf3bm5ps4rgfgv5lg2a8mzpc1ga";
      })
    ];

    nativeBuildInputs = [
      # needed to create the output wheel in installPhase
      python
      setuptools
      wheel
      absl-py
      tensorflow
    ];

    bazelTarget = ":pip_pkg";

    fetchAttrs = {
      sha256 = "1qw7vkwnxy45z4vm94isq5m96xiz35sigag7vjg1xb2sklbymxh8";
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
    gast
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
    broken = true;  # tf-probability 0.8.0 is not compatible with tensorflow 2.3.2
    description = "Library for probabilistic reasoning and statistical analysis";
    homepage = "https://www.tensorflow.org/probability/";
    license = licenses.asl20;
    maintainers = with maintainers; [];  # This package is maintainerless.
  };
}
