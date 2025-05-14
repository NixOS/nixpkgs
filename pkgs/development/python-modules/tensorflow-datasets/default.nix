{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # dependencies
  array-record,
  dill,
  dm-tree,
  future,
  immutabledict,
  importlib-resources,
  numpy,
  promise,
  protobuf,
  psutil,
  requests,
  simple-parsing,
  six,
  tensorflow-metadata,
  termcolor,
  tqdm,

  # tests
  apache-beam,
  beautifulsoup4,
  click,
  datasets,
  ffmpeg,
  imagemagick,
  jax,
  jaxlib,
  jinja2,
  langdetect,
  lxml,
  matplotlib,
  mlcroissant,
  mwparserfromhell,
  mwxml,
  networkx,
  nltk,
  opencv4,
  pandas,
  pillow,
  pycocotools,
  pydub,
  pytest-xdist,
  pytestCheckHook,
  scikit-image,
  scipy,
  sortedcontainers,
  tensorflow,
  tifffile,
  zarr,
}:

buildPythonPackage rec {
  pname = "tensorflow-datasets";
  version = "4.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "datasets";
    tag = "v${version}";
    hash = "sha256-nqveZ+8b0f5sGIn6WufKeA37yEsZjzhCIbCfwMZ9JOM=";
  };

  patches = [
    # mlmlcroissant uses encoding_formats, not encoding_formats.
    # Backport https://github.com/tensorflow/datasets/pull/11037 until released.
    (fetchpatch {
      url = "https://github.com/tensorflow/datasets/commit/92cbcff725a1036569a515cc3356aa8480740451.patch";
      hash = "sha256-2hnMvQP83+eAJllce19aHujcoWQzUz3+LsasWCo4BtM=";
    })
  ];

  dependencies = [
    array-record
    dill
    dm-tree
    future
    immutabledict
    importlib-resources
    numpy
    promise
    protobuf
    psutil
    requests
    simple-parsing
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
    mlcroissant
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
    sortedcontainers
    tensorflow
    tifffile
    zarr
  ];

  pytestFlagsArray = [
    # AttributeError: 'NoneType' object has no attribute 'Table'
    "--deselect=tensorflow_datasets/core/file_adapters_test.py::test_read_write"
    "--deselect=tensorflow_datasets/text/c4_wsrs/c4_wsrs_test.py::C4WSRSTest"
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
    "tensorflow_datasets/datasets/imagenet2012_corrupted/imagenet2012_corrupted_dataset_builder_test.py"

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

    # AttributeError: 'NoneType' object has no attribute 'Table'
    "tensorflow_datasets/core/dataset_builder_beam_test.py"
    "tensorflow_datasets/core/dataset_builders/adhoc_builder_test.py"
    "tensorflow_datasets/core/split_builder_test.py"
    "tensorflow_datasets/core/writer_test.py"

    # Requires `tensorflow_io` which is not packaged in `nixpkgs`.
    "tensorflow_datasets/core/features/audio_feature_test.py"
    "tensorflow_datasets/image/lsun_test.py"

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

  meta = {
    description = "Library of datasets ready to use with TensorFlow";
    homepage = "https://www.tensorflow.org/datasets/overview";
    changelog = "https://github.com/tensorflow/datasets/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
