{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cysignals,
  cython,
  setuptools,

  # native dependencies
  pkg-config,
  leptonica,
  tesseract5,

  # dependencies
  pillow,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tesserocr";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sirfz";
    repo = "tesserocr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y/3MXkocO4hRMjREPT6yvqH87EZm79zerinp5TUHNP4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "Cython>=3.0.0,<3.2.0" \
        "Cython"
  '';

  build-system = [
    cysignals
    cython
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    leptonica
    tesseract5
  ];

  dependencies = [
    cysignals # also needed at runtime
    pillow
  ];

  pythonImportsCheck = [ "tesserocr" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf tesserocr
  '';

  disabledTests = [
    # AssertionError: '.bl' != '.tif'
    "test_init_full"
  ];

  meta = {
    description = "Simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = lib.platforms.unix;
  };
})
