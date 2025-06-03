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
  pytest,
}:

let
  version = "0.19.3";
in
buildPythonPackage {
  pname = "swcgeom";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yzx9";
    repo = "swcgeom";
    tag = "v${version}";
    hash = "sha256-mpp8Dw0XcU59fYt7vjswAnXCmrRP3mhbgTDG+J4UwzI=";
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

  nativeCheckInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "swcgeom"
  ];

  meta = {
    description = "Neuron geometry library for swc format";
    homepage = "https://github.com/yzx9/swcgeom";
    changelog = "https://github.com/yzx9/swcgeom/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
