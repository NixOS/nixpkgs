{ stdenv
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.deprecation";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df";
  };

  buildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.deprecation;
    description = "Zope Deprecation Infrastructure";
    license = licenses.zpl20;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
