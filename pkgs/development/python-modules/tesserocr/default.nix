{
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
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
  version = "2.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vlGNGxtf9UwRqtoeD9EpQlCepwWB4KizmipHOgstvTY=";
  };

  patches = [
    # Backport https://github.com/sirfz/tesserocr/pull/364 to fix tests
    (fetchpatch {
      url = "https://github.com/sirfz/tesserocr/commit/853a885d0154a0345e1ea7db80febe04893a3da8.patch";
      hash = "sha256-s51s9EIV9AZT6UoqwTuQ8lOjToqwIIUkDLjsvCsyYFU=";
    })
  ];

  # https://github.com/sirfz/tesserocr/issues/314
  postPatch = ''
    sed -i '/allheaders.h/a\    pass\n\ncdef extern from "leptonica/pix_internal.h" nogil:' tesserocr/tesseract.pxd

    substituteInPlace setup.py \
      --replace-fail "Cython>=0.23,<3.1.0" Cython
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
