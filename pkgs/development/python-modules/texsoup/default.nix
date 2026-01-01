{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "texsoup";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alvinwan";
    repo = "TexSoup";
    tag = version;
    hash = "sha256-XKYJycYivtrszU46B3Bd4JLrvckBpQu9gKDMdr6MyZU=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "TexSoup" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

<<<<<<< HEAD
  meta = {
    description = "Fault-tolerant Python3 package for searching, navigating, and modifying LaTeX documents";
    homepage = "https://github.com/alvinwan/TexSoup";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    description = "Fault-tolerant Python3 package for searching, navigating, and modifying LaTeX documents";
    homepage = "https://github.com/alvinwan/TexSoup";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
