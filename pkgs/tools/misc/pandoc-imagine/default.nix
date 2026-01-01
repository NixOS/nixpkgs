{
  fetchFromGitHub,
  buildPythonApplication,
  lib,
  pandocfilters,
  six,
}:

buildPythonApplication rec {
  pname = "pandoc-imagine";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "imagine";
    owner = "hertogp";
    rev = version;
    sha256 = "sha256-IJAXrJakKjROF2xi9dsLvGzyGIyB+GDnx/Z7BRlwSqc=";
  };

  propagatedBuildInputs = [
    pandocfilters
    six
  ];

  # No tests in archive
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = src.meta.homepage;
    description = ''
      A pandoc filter that will turn code blocks tagged with certain classes
      into images or ASCII art
    '';
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ synthetica ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ synthetica ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pandoc-imagine";
  };
}
