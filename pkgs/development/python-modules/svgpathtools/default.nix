{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  svgwrite,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svgpathtools";
<<<<<<< HEAD
  version = "1.7.2";
=======
  version = "1.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mathandy";
    repo = "svgpathtools";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-OGengjPIEuxDYHqzFUBbYcVs9RjBSKSd1NNjx/KqnSk=";
=======
    hash = "sha256-SzYssDJ+uGb5zXZ16XaMCvIPF8BKJ4VVI/gUghz1IyA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    svgwrite
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "svgpathtools"
  ];

  meta = {
    description = "Collection of tools for manipulating and analyzing SVG Path objects and Bezier curves";
    homepage = "https://github.com/mathandy/svgpathtools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
