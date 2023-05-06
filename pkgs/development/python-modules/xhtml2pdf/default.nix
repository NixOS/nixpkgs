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
  version = "0.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    # Currently it is not possible to fetch from version as there is a branch with the same name
    rev = "refs/tags/${version}";
    hash = "sha256-MrzAsa0AZX3+0LN/Can3QBoPBRxb0a/F2jLBd8rD5H4=";
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

  pythonImportsCheck = [
    "xhtml2pdf"
  ];

  meta = with lib; {
    description = "A PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
