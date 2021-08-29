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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cc7d4r11z26rhcwpmcc42fi9kr3f20nq5pk84jrczr18i0g99mh";
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
