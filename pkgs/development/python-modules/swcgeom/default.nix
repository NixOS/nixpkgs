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

buildPythonPackage (finalAttrs: {
  pname = "swcgeom";
  version = "0.21.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yzx9";
    repo = "swcgeom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QLo2tfoQFuoKee/e/t5l3bUwOtobV57Od9UvAze78FE=";
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
    changelog = "https://github.com/yzx9/swcgeom/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
