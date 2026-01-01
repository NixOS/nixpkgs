{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "tailer";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "six8";
    repo = "pytailer";
    rev = version;
    sha256 = "1s5p5m3q9k7r1m0wx5wcxf20xzs0rj14qwg1ydwhf6adr17y2w5y";
  };

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m doctest -v src/tailer/__init__.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "tailer" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation implementation of GNU tail and head";
    mainProgram = "pytail";
    homepage = "https://github.com/six8/pytailer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python implementation implementation of GNU tail and head";
    mainProgram = "pytail";
    homepage = "https://github.com/six8/pytailer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
