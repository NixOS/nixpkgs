{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, html5lib
, pypdf2
, reportlab
, six
}:

buildPythonPackage rec {
  pname = "xhtml2pdf";
  version = "0.2.4";

  propagatedBuildInputs = [pillow html5lib pypdf2 reportlab six];

  src = fetchPypi {
    inherit pname version;
    sha256 = "6793fbbdcb6bb8a4a70132966d8d95e95ea3498cdf0e82252d2b8e9aae34fcb5";
  };

  meta = with stdenv.lib; {
    description = "A PDF generator using HTML and CSS";
    homepage = "https://github.com/xhtml2pdf/xhtml2pdf";
    license = licenses.asl20;
  };

}
