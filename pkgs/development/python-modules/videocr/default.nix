{ lib
, buildPythonPackage
, fetchPypi
, levenshtein
, pytesseract
, opencv4
, fuzzywuzzy
}:

buildPythonPackage rec {
  pname = "videocr";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1clifwczvhvbaw2spgxkkyqsbqh21vyfw3rh094pxfmq89ylyj63";
  };

  propagatedBuildInputs = [
    levenshtein
    pytesseract
    opencv4
    fuzzywuzzy
  ];

  postPatch = ''
    substituteInPlace setup.py \
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
