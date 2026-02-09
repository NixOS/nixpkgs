{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build-system
  cython,
  pkg-config,
  setuptools,

  # native dependencies
  leptonica,
  tesseract4,

  # dependencies
  pillow,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "tesserocr";
  version = "2.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L6H+PHlXXW/VtSd4Xnc/oZsFXwf5Iv6yrJ1sHmIjNSI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "Cython>=3.0.0,<3.2.0" Cython
  '';

  build-system = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [
    leptonica
    tesseract4
  ];

  dependencies = [ pillow ];

  pythonImportsCheck = [ "tesserocr" ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    rm -rf tesserocr
  '';

  meta = {
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/v${version}";
    description = "Simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = lib.platforms.unix;
  };
}
