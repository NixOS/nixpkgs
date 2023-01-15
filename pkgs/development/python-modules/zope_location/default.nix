{ lib
, buildPythonPackage
, fetchPypi
, zope_proxy
}:

buildPythonPackage rec {
  pname = "zope.location";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Fx7tyKIOw6isJxOaqQzyd/93dy6gMrVLaicBp5J7OsU=";
  };

  propagatedBuildInputs = [ zope_proxy ];

  # ignore circular dependency on zope_schema
  preBuild = ''
    sed -i '/zope.schema/d' setup.py
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.location/";
    description = "Zope Location";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
