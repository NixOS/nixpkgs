{ stdenv
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.deprecation";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f6prwp9xkjhaj12pyickxnhgfyd06mg3l9yr0i7pdw8afxwacpz";
  };

  buildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.deprecation;
    description = "Zope Deprecation Infrastructure";
    license = licenses.zpl20;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
