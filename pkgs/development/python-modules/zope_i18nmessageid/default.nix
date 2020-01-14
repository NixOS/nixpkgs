{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "zope.i18nmessageid";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03318270df5320c57b3416744f9cb2a85160a8d00345c07ac35d2b7ac01ff50c";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18nmessageid;
    description = "Message Identifiers for internationalization";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
