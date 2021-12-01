{ lib
, buildPythonPackage
, fetchPypi
, pillow
, html5lib
, pypdf2
, reportlab
, six
, python-bidi
, arabic-reshaper
, setuptools
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.5";

  propagatedBuildInputs = [
    pillow html5lib pypdf2 reportlab six
    setuptools python-bidi arabic-reshaper
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "6797e974fac66f0efbe927c1539a2756ca4fe8777eaa5882bac132fc76b39421";
  };

  meta = with lib; {
    description = "A PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    license = licenses.asl20;
  };

}
