{ stdenv
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.size";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f3eb687c9181e3b7400c5cd4d4209a2f676475b7b85c99ee11de2404b3493ec";
  };

  propagatedBuildInputs = [ zope_i18nmessageid zope_interface ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.size;
    description = "Interfaces and simple adapter that give the size of an object";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
