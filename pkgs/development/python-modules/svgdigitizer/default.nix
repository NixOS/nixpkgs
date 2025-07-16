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
  version = "0.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echemdb";
    repo = "svgdigitizer";
    tag = version;
    hash = "sha256-aodPjms92+/6bbheIs/8w+M4T+mfw5PWf1dsxFuojwA=";
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
    description = "(x,y) Data Points from SVG files";
    homepage = "https://github.com/echemdb/svgdigitizer";
    changelog = "https://github.com/echemdb/svgdigitizer/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
    # https://github.com/echemdb/svgdigitizer/issues/252
    broken = stdenv.hostPlatform.isDarwin;
  };
}
