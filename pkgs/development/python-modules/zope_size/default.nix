{ lib
, buildPythonPackage
, fetchPypi
, zope-i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.size";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bhv3QJdZtNpyAuL6/aZXWD1Acx8661VweWaItJPpkHk=";
  };

  propagatedBuildInputs = [ zope-i18nmessageid zope_interface ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
