{
  lib,
  buildPythonPackage,
  cssselect2,
  fetchPypi,
  hatchling,
  lxml,
  pillow,
  pytestCheckHook,
  reportlab,
  tinycss2,
}:

buildPythonPackage rec {
  pname = "svglib";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-veXF+bDgkfHiELiq/doHpJvY6/IcDpDWc4OmZcg1l6w=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    cssselect2
    lxml
    pillow
    reportlab
    tinycss2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Ignore tests that require network access (TestWikipediaFlags and TestW3CSVG), and tests that
    # require files missing in the 1.0.0 PyPI release (TestOtherFiles).
    "TestWikipediaFlags"
    "TestW3CSVG"
    "TestOtherFiles"
  ];

  pythonImportsCheck = [ "svglib.svglib" ];

  meta = {
    description = "Pure-Python library for reading and converting SVG";
    homepage = "https://github.com/deeplook/svglib";
    changelog = "https://github.com/deeplook/svglib/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
    mainProgram = "svg2pdf";
  };
}
