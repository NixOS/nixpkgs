{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.lifecycleevent";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s5brphqzzz89cykg61gy7zcmz0ryq1jj2va7gh2n1b3cccllp95";
  };

  propagatedBuildInputs = [ zope_event zope_component ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.lifecycleevent;
    description = "Object life-cycle events";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
