{ stdenv
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.deprecation";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fed622b51ffc600c13cc5a5b6916b8514c115f34f7ea2730409f30c061eb0b78";
  };

  buildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.deprecation;
    description = "Zope Deprecation Infrastructure";
    license = licenses.zpl20;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
