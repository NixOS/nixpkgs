{
  lib,
  buildPythonPackage,
  fetchPypi,
  levenshtein,
  pytesseract,
  opencv4,
  fuzzywuzzy,
}:

buildPythonPackage rec {
  pname = "videocr";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w0hPfUK4un5JAjAP7vwOAuKlsZ+zv6sFV2vD/Rl3kbI=";
  };

  propagatedBuildInputs = [
    levenshtein
    pytesseract
    opencv4
    fuzzywuzzy
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python-Levenshtein" "Levenshtein" \
      --replace "opencv-python" "opencv"
    substituteInPlace videocr/constants.py \
      --replace "master" "main"
    substituteInPlace videocr/video.py \
      --replace '--tessdata-dir "{}"' '--tessdata-dir="{}"'
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "videocr" ];

  meta = with lib; {
    description = "Extract hardcoded subtitles from videos using machine learning";
    homepage = "https://github.com/apm1467/videocr";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
  };
}
