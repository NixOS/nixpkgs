{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  levenshtein,
  pytesseract,
  opencv-python,
  fuzzywuzzy,
}:

buildPythonPackage rec {
  pname = "videocr";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w0hPfUK4un5JAjAP7vwOAuKlsZ+zv6sFV2vD/Rl3kbI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    levenshtein
    pytesseract
    opencv-python
    fuzzywuzzy
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "python-Levenshtein" "Levenshtein"
    substituteInPlace videocr/constants.py \
      --replace-fail "master" "main"
    substituteInPlace videocr/video.py \
      --replace-fail '--tessdata-dir "{}"' '--tessdata-dir="{}"'
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
