{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.contenttype";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9decc7531ad6925057f1a667ac0ef9d658577a92b0b48dafa7daa97b78a02bbb";
  };

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.contenttype;
    description = "A utility module for content-type (MIME type) handling";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
