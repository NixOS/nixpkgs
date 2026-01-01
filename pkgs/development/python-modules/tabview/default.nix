{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "tabview";
  version = "1.4.4";
  format = "setuptools";

  # newest release only available as wheel on pypi
  src = fetchFromGitHub {
    owner = "TabViewer";
    repo = "tabview";
    rev = version;
    sha256 = "1d1l8fhdn3w2zg7wakvlmjmgjh9lh9h5fal1clgyiqmhfix4cn4m";
  };

  nativeCheckInputs = [ unittestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python curses command line CSV and tabular data viewer";
    mainProgram = "tabview";
    homepage = "https://github.com/TabViewer/tabview";
    changelog = "https://github.com/TabViewer/tabview/blob/main/CHANGELOG.rst";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
