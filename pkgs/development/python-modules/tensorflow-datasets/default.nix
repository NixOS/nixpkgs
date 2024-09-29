{
  apache-beam,
  array-record,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  click,
  datasets,
  dill,
  dm-tree,
  fetchFromGitHub,
  ffmpeg,
  future,
  imagemagick,
  importlib-resources,
  jax,
  jaxlib,
  jinja2,
  langdetect,
  lib,
  lxml,
  matplotlib,
  mwparserfromhell,
  mwxml,
  networkx,
  nltk,
  numpy,
  opencv4,
  pandas,
  pillow,
  promise,
  protobuf,
  psutil,
  pycocotools,
  pydub,
  pytest-xdist,
  pytestCheckHook,
  requests,
  scikit-image,
  scipy,
  six,
  tensorflow,
  tensorflow-metadata,
  termcolor,
  tifffile,
  tqdm,
  zarr,
}:

buildPythonPackage rec {
  pname = "tensorflow-datasets";
  version = "4.9.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "datasets";
    rev = "refs/tags/v${version}";
    hash = "sha256-2zR1b/Zkj3hcwiVK7wdxix3taNgFFOxqy7fSge6dAIk=";
  };

  patches = [
    # addresses https://github.com/tensorflow/datasets/issues/3673
    ./corruptions.patch
  ];

  propagatedBuildInputs = [
    array-record
    attrs
    dill
    dm-tree
    future
    importlib-resources
    numpy
    promise
    protobuf
    psutil
    requests
    six
    tensorflow-metadata
    termcolor
    tqdm
  ];

  pythonImportsCheck = [ "tensorflow_datasets" ];

  nativeCheckInputs = [
    apache-beam
    beautifulsoup4
    click
    datasets
    ffmpeg
    imagemagick
    jax
    jaxlib
    jinja2
    langdetect
    lxml
    matplotlib
    mwparserfromhell
    mwxml
    networkx
    nltk
    opencv4
    pandas
    pillow
    pycocotools
    pydub
    pytest-xdist
    pytestCheckHook
    scikit-image
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
    "tensorflow_datasets/core/registered_test.py"
    "tensorflow_datasets/core/utils/gcs_utils_test.py"
    "tensorflow_datasets/import_without_tf_test.py"
    "tensorflow_datasets/proto/build_tf_proto_test.py"
    "tensorflow_datasets/scripts/cli/build_test.py"

    # Requires `pretty_midi` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/audio/groove.py"
    "tensorflow_datasets/datasets/groove/groove_dataset_builder_test.py"

    # Requires `crepe` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/audio/nsynth.py"
    "tensorflow_datasets/datasets/nsynth/nsynth_dataset_builder_test.py"

    # Requires `conllu` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/core/dataset_builders/conll/conllu_dataset_builder_test.py"
    "tensorflow_datasets/datasets/universal_dependencies/universal_dependencies_dataset_builder_test.py"
    "tensorflow_datasets/datasets/xtreme_pos/xtreme_pos_dataset_builder_test.py"

    # Requires `gcld3` and `pretty_midi` which are not packaged in `nixpkgs`.
    "tensorflow_datasets/core/lazy_imports_lib_test.py"

    # Requires `tensorflow_io` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/core/features/audio_feature_test.py"
    "tensorflow_datasets/image/lsun_test.py"

    # Requires `envlogger` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/rlds/locomotion/locomotion_test.py"
    "tensorflow_datasets/rlds/robosuite_panda_pick_place_can/robosuite_panda_pick_place_can_test.py"

    # Fails with `TypeError: Constant constructor takes either 0 or 2 positional arguments`
    # deep in TF AutoGraph. Doesn't reproduce in Docker with Ubuntu 22.04 => might be related
    # to the differences in some of the dependencies?
    "tensorflow_datasets/rl_unplugged/rlu_atari/rlu_atari_test.py"

    # Fails with `ValueError: setting an array element with a sequence`
    "tensorflow_datasets/core/dataset_utils_test.py"
    "tensorflow_datasets/core/features/sequence_feature_test.py"

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
