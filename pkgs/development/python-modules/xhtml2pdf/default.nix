{
  lib,
  arabic-reshaper,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  html5lib,
  pillow,
  pyhanko,
  pyhanko-certvalidator,
  pypdf,
  pytestCheckHook,
  python-bidi,
  pythonOlder,
  pythonRelaxDepsHook,
  reportlab,
  setuptools,
  svglib,
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "xhtml2pdf";
    repo = "xhtml2pdf";
    rev = "refs/tags/v${version}";
    hash = "sha256-JXxh/n1kUsy3O4P/6WTfa5p+mYy/t4ZBUhlHp+ypoQc=";
  };

  patches = [
    # https://github.com/xhtml2pdf/xhtml2pdf/pull/754
    (fetchpatch2 {
      name = "reportlab-compat.patch";
      url = "https://github.com/xhtml2pdf/xhtml2pdf/commit/1252510bd23b833b45b4d252aeac62c1eb51eeef.patch";
      hash = "sha256-9Fkn086uh2biabmiChbBna8Q4lJV/604yX1ng9j5TGs=";
    })
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [ "reportlab" ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    changelog = "https://github.com/xhtml2pdf/xhtml2pdf/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "xhtml2pdf";
  };
}
