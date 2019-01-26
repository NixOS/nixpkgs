{ stdenv
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.deprecation";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d52e134bbaaa0d72e1e2bc90f0587f1adc116c4bdf15912afaf2f1e8856b224";
  };

  buildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.deprecation;
    description = "Zope Deprecation Infrastructure";
    license = licenses.zpl20;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
