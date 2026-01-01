{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stringzilla";
<<<<<<< HEAD
  version = "4.6.0";
=======
  version = "4.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "stringzilla";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5WAD5ZpzhdIDv1kUVinc5z91N/tQVScO75kOPC1WWlY=";
=======
    hash = "sha256-MitvjIb+mBK22hxjtqbVB6kYP7pdvF5LxWiS2R/6Jk4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  enabledTestPaths = [ "scripts/test_stringzilla.py" ];

<<<<<<< HEAD
  disabledTests = [
    # test downloads CaseFolding.txt from unicode.org
    "test_utf8_case_fold_all_codepoints"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    changelog = "https://github.com/ashvardanian/StringZilla/releases/tag/${src.tag}";
    description = "SIMD-accelerated string search, sort, hashes, fingerprints, & edit distances";
    homepage = "https://github.com/ashvardanian/stringzilla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aciceri
      dotlambda
    ];
  };
}
