{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "echemdb";
    repo = "svgdigitizer";
    tag = version;
    hash = "sha256-7F1q0AvkeqLIoWDNNBUc/91caiQ7kdIcKOkvdAajsLI=";
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
  env.MPLBACKEND = "Agg";

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlags = [
    "--doctest-modules"
    "svgdigitizer"
  ];

  disabledTests = [
    # test tries to connect to doi.org
    "svgdigitizer.pdf.Pdf.bibliographic_entry"
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
