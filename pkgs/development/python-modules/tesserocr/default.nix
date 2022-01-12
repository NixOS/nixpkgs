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
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bmj76gi8401lcqdaaznfmz9yf11myy1bzivqwwq08z3dwzxswck";
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
