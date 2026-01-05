{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build system
  setuptools,

  # dependencies
  absl-py,
  array-record,
  dm-tree,
  etils,
  immutabledict,
  numpy,
  promise,
  protobuf,
  psutil,
  pyarrow,
  requests,
  simple-parsing,
  tensorflow-metadata,
  termcolor,
  toml,
  tqdm,
  wrapt,
  pythonOlder,
  importlib-resources,

  # tests
  apache-beam,
  beautifulsoup4,
  click,
  cloudpickle,
  datasets,
  dill,
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
  version = "4.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "datasets";
    tag = "v${version}";
    hash = "sha256-ZXaPYmj8aozfe6ygzKybId8RZ1TqPuIOSpd8XxnRHus=";
  };

  patches = [
    # TypeError: Cannot handle this data type: (1, 1, 4), <u2
    # Issue: https://github.com/tensorflow/datasets/issues/11148
    # PR: https://github.com/tensorflow/datasets/pull/11149
    (fetchpatch2 {
      name = "fix-pillow-12-compat";
      url = "https://github.com/tensorflow/datasets/pull/11149/commits/21062d65b33978f2263443280c03413add5c0224.patch";
      hash = "sha256-GWb+1E5lQNhFVp57sqjp+WqzZSva1AGpXe9fbvXXeIA=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    array-record
    dm-tree
    etils
    immutabledict
    numpy
    promise
    protobuf
    psutil
    pyarrow
    requests
    simple-parsing
    tensorflow-metadata
    termcolor
    toml
    tqdm
    wrapt
  ]
  ++ etils.optional-dependencies.epath
  ++ etils.optional-dependencies.etree
  ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  pythonImportsCheck = [ "tensorflow_datasets" ];

  nativeCheckInputs = [
    apache-beam
    beautifulsoup4
    click
    cloudpickle
    datasets
    dill
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

  disabledTests = [
    # Since updating apache-beam to 2.65.0
    # RuntimeError: Unable to pickle fn CallableWrapperDoFn...: maximum recursion depth exceeded
    # https://github.com/tensorflow/datasets/issues/11055
    "test_download_and_prepare_as_dataset"
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

    # AttributeError: 'NoneType' object has no attribute 'Table'
    "tensorflow_datasets/core/file_adapters_test.py::test_read_write"
    "tensorflow_datasets/text/c4_wsrs/c4_wsrs_test.py::C4WSRSTest"
  ];

  meta = {
    description = "Library of datasets ready to use with TensorFlow";
    homepage = "https://www.tensorflow.org/datasets/overview";
    changelog = "https://github.com/tensorflow/datasets/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
