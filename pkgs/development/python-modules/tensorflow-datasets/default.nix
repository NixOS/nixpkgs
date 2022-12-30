{ apache-beam
, attrs
, beautifulsoup4
, buildPythonPackage
, dill
, dm-tree
, fetchFromGitHub
, ffmpeg
, future
, imagemagick
, importlib-resources
, jax
, jaxlib
, jinja2
, langdetect
, lib
, matplotlib
, mwparserfromhell
, networkx
, nltk
, numpy
, opencv4
, pandas
, pillow
, promise
, protobuf
, pycocotools
, pydub
, pytest-xdist
, pytestCheckHook
, requests
, scikitimage
, scipy
, six
, tensorflow
, tensorflow-metadata
, termcolor
, tifffile
, tqdm
, zarr
}:

buildPythonPackage rec {
  pname = "tensorflow-datasets";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "datasets";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-YG0Abb5xdTaq+/0I45KU02wuZHyLKD5oMSINJOy7Nrk=";
  };

  patches = [
    # addresses https://github.com/tensorflow/datasets/issues/3673
    ./corruptions.patch
  ];

  propagatedBuildInputs = [
    attrs
    dill
    dm-tree
    future
    importlib-resources
    numpy
    promise
    protobuf
    requests
    six
    tensorflow-metadata
    termcolor
    tqdm
  ];

  pythonImportsCheck = [
    "tensorflow_datasets"
  ];

  checkInputs = [
    apache-beam
    beautifulsoup4
    ffmpeg
    imagemagick
    jax
    jaxlib
    jinja2
    langdetect
    matplotlib
    mwparserfromhell
    networkx
    nltk
    opencv4
    pandas
    pillow
    pycocotools
    pydub
    pytest-xdist
    pytestCheckHook
    scikitimage
    scipy
    tensorflow
    tifffile
    zarr
  ];

  disabledTestPaths = [
    # Sandbox violations: network access, filesystem write attempts outside of build dir, ...
    "tensorflow_datasets/core/dataset_builder_test.py"
    "tensorflow_datasets/core/dataset_info_test.py"
    "tensorflow_datasets/core/features/features_test.py"
    "tensorflow_datasets/core/github_api/github_path_test.py"
    "tensorflow_datasets/core/utils/gcs_utils_test.py"
    "tensorflow_datasets/scripts/cli/build_test.py"

    # Requires `pretty_midi` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/audio/groove_test.py"

    # Requires `crepe` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/audio/nsynth_test.py"

    # Requires `gcld3` and `pretty_midi` which are not packaged in `nixpkgs`.
    "tensorflow_datasets/core/lazy_imports_lib_test.py"

    # Requires `tensorflow_io` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/image/lsun_test.py"

    # Requires `envlogger` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/rlds/locomotion/locomotion_test.py"
    "tensorflow_datasets/rlds/robosuite_panda_pick_place_can/robosuite_panda_pick_place_can_test.py"

    # Fails with `TypeError: Constant constructor takes either 0 or 2 positional arguments`
    # deep in TF AutoGraph. Doesn't reproduce in Docker with Ubuntu 22.04 => might be related
    # to the differences in some of the dependencies?
    "tensorflow_datasets/rl_unplugged/rlu_atari/rlu_atari_test.py"

    # Requires `tensorflow_docs` which is not packaged in `nixpkgs` and the test is for documentation anyway.
    "tensorflow_datasets/scripts/documentation/build_api_docs_test.py"

    # Not a test, should not be executed.
    "tensorflow_datasets/testing/test_utils.py"

    # Require `gcld3` and `nltk.punkt` which are not packaged in `nixpkgs`.
    "tensorflow_datasets/text/c4_test.py"
    "tensorflow_datasets/text/c4_utils_test.py"
  ];

  meta = with lib; {
    description = "Library of datasets ready to use with TensorFlow";
    homepage = "https://www.tensorflow.org/datasets/overview";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
