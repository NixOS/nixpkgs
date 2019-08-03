{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "zope.i18nmessageid";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e511edff8e75d3a6f84d8256e1e468c85a4aa9d89c2ea264a919334fae7081e3";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18nmessageid;
    description = "Message Identifiers for internationalization";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
