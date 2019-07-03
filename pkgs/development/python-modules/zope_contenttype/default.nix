{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.contenttype";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08c0408f515668e6f0c4fd492b66fbe87a074c1aa21cfc6be8c6292482d8b2f4";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.contenttype;
    description = "A utility module for content-type (MIME type) handling";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
