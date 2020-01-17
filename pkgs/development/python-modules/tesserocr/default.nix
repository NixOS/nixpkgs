{
  buildPythonPackage,
  fetchPypi,
  lib,
  # build dependencies
  cython,
  leptonica,
  pkg-config,
  tesseract,
  # extra python packages
  pillow
}:

buildPythonPackage rec {
  pname = "tesserocr";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nj33mwvppacy6p5mqk9a4x26hx9ailshgad84ks60wyms6rgjiv";
  };

  nativeBuildInputs = [ cython pkg-config ];
  buildInputs = [ leptonica tesseract ];
  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "A simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = licenses.mit;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
