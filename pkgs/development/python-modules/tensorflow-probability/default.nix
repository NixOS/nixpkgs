{
  lib,
  stdenv,

  # bazel wheel
  buildBazelPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  python,
  setuptools,
  wheel,
  absl-py,

  bazel_6,
  cctools,

  # python package
  buildPythonPackage,

  # dependencies
  cloudpickle,
  decorator,
  dm-tree,
  gast,
  keras,
  numpy,
  six,
  tensorflow,

  # tests
  hypothesis,
  matplotlib,
  mock,
  mpmath,
  pandas,
  pytest,
  scipy,
}:

let
  version = "0.24.0";
  pname = "tensorflow-probability";

  # first build all binaries and generate setup.py using bazel
  bazel-wheel = buildBazelPackage {
    name = "tensorflow_probability-${version}-py2.py3-none-any.whl";
    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "probability";
      rev = "refs/tags/v${version}";
      hash = "sha256-V6aw4NtGOHlvcbgLWMH29x81eck1PyzV93ANelvpL4c=";
    };
    nativeBuildInputs = [
      absl-py
      # needed to create the output wheel in installPhase
      python
      setuptools
      tensorflow
      wheel
    ];

    bazel = bazel_6;

    bazelTargets = [ ":pip_pkg" ];
    LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

    fetchAttrs = {
      sha256 = "sha256-TbWcWYidyXuAMgBnO2/k0NKCzc4wThf2uUeC3QxdBJY=";
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
in
buildPythonPackage {
  inherit version pname;
  format = "wheel";

  src = bazel-wheel;

  dependencies = [
    cloudpickle
    decorator
    dm-tree
    gast
    keras
    numpy
    six
    tensorflow
  ];

  # Listed here:
  # https://github.com/tensorflow/probability/blob/f3777158691787d3658b5e80883fe1a933d48989/testing/dependency_install_lib.sh#L83
  nativeCheckInputs = [
    hypothesis
    matplotlib
    mock
    mpmath
    pandas
    pytest
    scipy
  ];

  # Ideally, we run unit tests with pytest, but in checkPhase, only the Bazel-build wheel is available.
  # But it seems not guaranteed that running the tests with pytest will even work, see
  # https://github.com/tensorflow/probability/blob/c2a10877feb2c4c06a4dc58281e69c37a11315b9/CONTRIBUTING.md?plain=1#L69
  # Ideally, tests would be run using Bazel. For now, lets's do a...

  # sanity check
  pythonImportsCheck = [ "tensorflow_probability" ];

  meta = {
    description = "Library for probabilistic reasoning and statistical analysis";
    homepage = "https://www.tensorflow.org/probability/";
    changelog = "https://github.com/tensorflow/probability/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
