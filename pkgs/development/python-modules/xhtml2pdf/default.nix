{
  lib,
  arabic-reshaper,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  pillow,
  pyhanko,
  pyhanko-certvalidator,
  pypdf,
  pytestCheckHook,
  python-bidi,
  pythonOlder,
  reportlab,
  setuptools,
  svglib,
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.17";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "xhtml2pdf";
    repo = "xhtml2pdf";
    tag = "v${version}";
    hash = "sha256-qp0JVp5efIrI98YT0rwFAMSEW+0aIhedfYGND4V7Mto=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    arabic-reshaper
    html5lib
    pillow
    pyhanko
    pyhanko-certvalidator
    pypdf
    python-bidi
    reportlab
    svglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests requires network access
    "test_document_cannot_identify_image"
    "test_document_with_broken_image"
  ];

  pythonImportsCheck = [
    "xhtml2pdf"
    "xhtml2pdf.pisa"
  ];

  meta = {
    changelog = "https://github.com/xhtml2pdf/xhtml2pdf/releases/tag/${src.tag}";
    description = "PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    license = lib.licenses.asl20;
    mainProgram = "xhtml2pdf";
    maintainers = [ ];
  };
}
