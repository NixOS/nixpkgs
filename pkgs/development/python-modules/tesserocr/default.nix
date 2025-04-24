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
  version = "2.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0TFyLur8YFyhJx3Mb4A3C5eRPjFVtN8hQ54h5SuCvQ=";
  };

  # https://github.com/sirfz/tesserocr/issues/314
  postPatch = ''
    sed -i '/allheaders.h/a\    pass\n\ncdef extern from "leptonica/pix_internal.h" nogil:' tesserocr/tesseract.pxd
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

  meta = with lib; {
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/v${version}";
    description = "Simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = licenses.mit;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
