{ lib
, arabic-reshaper
, buildPythonPackage
, fetchFromGitHub
, html5lib
, pillow
, pyhanko
, pypdf3
, pytestCheckHook
, python-bidi
, pythonOlder
, reportlab
, svglib
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    # Currently it is not possible to fetch from version as there is a branch with the same name
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zWzg/r18wjzxWyD5QJ7l4pY+4bJTvHjrD11FRuuy8H8=";
  };

  propagatedBuildInputs = [
    arabic-reshaper
    html5lib
    pillow
    pyhanko
    pypdf3
    python-bidi
    reportlab
    svglib
  ];

  checkInputs = [
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
