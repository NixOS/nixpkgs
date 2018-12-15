{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.i18nmessageid";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18nmessageid;
    description = "Message Identifiers for internationalization";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
