{ lib
, fetchurl
, buildPythonPackage
, cairosvg
, cffi
, cssselect
, glib
, html5lib
, lxml
, pango
, pygobject2
, Pyphen
, tinycss
, pytest
, fontconfig
}:

let
  pname = "WeasyPrint";
  version = "0.34";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "5afb18e90bb6da4c11ffc31730f30c7f6f40bc828d58376756e1dc8757e38e06";
  };
# Need to fix a couple more libraries!
  postPatch = ''
    substituteInPlace weasyprint/text.py --replace "libgobject-2.0.so" "${glib.out}/lib/libgobject-2.0.so"
    substituteInPlace weasyprint/text.py --replace "libpango-1.0.so" "${pango.out}/lib/libpango-1.0.so"
    substituteInPlace weasyprint/text.py --replace "libpangocairo-1.0.so" "${pango.out}/lib/libpangocairo-1.0.so"
    substituteInPlace weasyprint/fonts.py --replace "libfontconfig.so.1" "${fontconfig.lib}/lib/libfontconfig.so.1"
    substituteInPlace weasyprint/fonts.py --replace "libpangoft2-1.0.so" "${pango.out}/lib/libpangoft2-1.0.so"

  '';

  checkPhase = ''
    py.test
  '';

  doCheck = false;



  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cairosvg Pyphen cffi cssselect lxml html5lib tinycss pygobject2 ];


  meta = {
    homepage = http://weasyprint.org/;
    description = "Converts web documents to PDF";
    license = lib.licenses.bsd3;
  };
}
