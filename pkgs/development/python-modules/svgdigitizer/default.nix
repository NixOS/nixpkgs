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

buildPythonPackage (finalAttrs: {
  pname = "svgdigitizer";
  version = "0.14.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "echemdb";
    repo = "svgdigitizer";
    tag = finalAttrs.version;
    hash = "sha256-7a+IY3bxZI3DpkyUx4TQeDNBz80LhfK4s70Bl94liM0=";
  };

  build-system = [
    setuptools
  ];

  # https://github.com/echemdb/svgdigitizer/issues/298
  pythonRelaxDeps = [
    "astropy"
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
    changelog = "https://github.com/echemdb/svgdigitizer/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
