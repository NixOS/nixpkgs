{ lib
, arabic-reshaper
, buildPythonPackage
, fetchFromGitHub
, html5lib
, pillow
, pyhanko
, pypdf
, pytestCheckHook
, python-bidi
, pythonOlder
, reportlab
, svglib
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-K7gsTLYcXmKmEQzOXrJ2kvvLzKaDkZ/NRLRc0USii5M=";
  };

  propagatedBuildInputs = [
    arabic-reshaper
    html5lib
    pillow
    pyhanko
    pypdf
    python-bidi
    reportlab
    svglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests requires network access
    "test_document_cannot_identify_image"
    "test_document_with_broken_image"
  ];

  pythonImportsCheck = [
    "xhtml2pdf"
    "xhtml2pdf.pisa"
  ];

  meta = with lib; {
    description = "A PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    changelog = "https://github.com/xhtml2pdf/xhtml2pdf/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "xhtml2pdf";
  };
}
