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
  version = "0.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    # Currently it is not possible to fetch from version as there is a branch with the same name
    rev = "afa72cdbbdaf7d459261c1605263101ffcd999af";
    sha256 = "sha256-plyIM7Ohnp5UBWz/UDTJa1UeWK9yckSZR16wxmLrpnc=";
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
