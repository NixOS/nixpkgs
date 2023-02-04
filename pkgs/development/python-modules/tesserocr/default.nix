{ buildPythonPackage
, fetchPypi
, lib

# build dependencies
, cython
, leptonica
, pkg-config
, tesseract

# propagates
, pillow

# tests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "tesserocr";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bmj76gi8401lcqdaaznfmz9yf11myy1bzivqwwq08z3dwzxswck";
  };

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    leptonica
    tesseract
  ];

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "tesserocr"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/v${version}";
    description = "A simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = licenses.mit;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
