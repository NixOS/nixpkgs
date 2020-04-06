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
  version = "0.2.3";

  propagatedBuildInputs = [pillow html5lib pypdf2 reportlab six];

  src = fetchPypi {
    inherit pname version;
    sha256 = "10kg8cmn7zgql2lb6cfmqj94sa0jkraksv3lc4kvpn58sxw7x8w6";
  };

  meta = with stdenv.lib; {
    description = "A PDF generator using HTML and CSS";
    homepage = https://github.com/xhtml2pdf/xhtml2pdf;
    license = licenses.asl20;
  };

}
