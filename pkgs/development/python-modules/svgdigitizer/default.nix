{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  astropy,
  click,
  frictionless,
  matplotlib,
  mergedeep,
  pandas,
  pillow,
  pybtex,
  pymupdf,
  pyyaml,
  scipy,
  svg-path,
  svgpathtools,
  svgwrite,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "svgdigitizer";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echemdb";
    repo = "svgdigitizer";
    tag = version;
    hash = "sha256-UlcvCfNoEijIKoqSbufEZ6988rqwT2xDEy4P/9fdgVM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    astropy
    click
    frictionless
    matplotlib
    mergedeep
    pandas
    pillow
    pybtex
    pymupdf
    pyyaml
    scipy
    svg-path
    svgpathtools
    svgwrite
  ];
  # https://github.com/echemdb/svgdigitizer/issues/252
  MPLBACKEND = "Agg";

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlags = [
    "--doctest-modules"
    "svgdigitizer"
  ];

  pythonImportsCheck = [
    "svgdigitizer"
  ];

  meta = {
    description = "Extract numerical data points from SVG files";
    homepage = "https://github.com/echemdb/svgdigitizer";
    changelog = "https://github.com/echemdb/svgdigitizer/blob/${src.tag}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
