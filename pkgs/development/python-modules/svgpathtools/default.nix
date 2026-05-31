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
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mathandy";
    repo = "svgpathtools";
    tag = "v${version}";
    hash = "sha256-OGengjPIEuxDYHqzFUBbYcVs9RjBSKSd1NNjx/KqnSk=";
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
