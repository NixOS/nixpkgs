{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  setuptools,
  wheel,
  imagecodecs,
  matplotlib,
  pandas,
  pynrrd,
  scipy,
  sdflit,
  seaborn,
  tifffile,
  tqdm,
  typing-extensions,
  beautifulsoup4,
  certifi,
  chardet,
  lmdb,
  requests,
  urllib3,
  pytestCheckHook,
}:

let
<<<<<<< HEAD
  version = "0.21.2";
=======
  version = "0.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage rec {
  pname = "swcgeom";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yzx9";
    repo = "swcgeom";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-A6N6i7GESMIhG81xXDsNXiM0yBXWGhcdELll79F3Evk=";
=======
    hash = "sha256-XMpDzjKwj9DQTT/LC0tcBcqO5yetP5JNQbTOGkHv9TM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cython
    numpy
    setuptools
    wheel
  ];

  dependencies = [
    imagecodecs
    matplotlib
    numpy
    pandas
    pynrrd
    scipy
    sdflit
    seaborn
    tifffile
    tqdm
    typing-extensions
  ];

  optional-dependencies = {
    all = [
      beautifulsoup4
      certifi
      chardet
      lmdb
      requests
      urllib3
    ];
  };

  pythonImportsCheck = [
    "swcgeom"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # make sure import the built version, not the source one
    rm -r swcgeom
  '';

  meta = {
    description = "Neuron geometry library for swc format";
    homepage = "https://github.com/yzx9/swcgeom";
    changelog = "https://github.com/yzx9/swcgeom/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
