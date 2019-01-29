{ stdenv
, buildPythonPackage
, fetchPypi
, zope_proxy
}:

buildPythonPackage rec {
  pname = "zope.location";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a720f9e3c8a51d5007ed6fcd47e1834df02671d85dbfd1062a0d808de8bf80ac";
  };

  propagatedBuildInputs = [ zope_proxy ];

  # ignore circular dependency on zope_schema
  preBuild = ''
    sed -i '/zope.schema/d' setup.py
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.location/;
    description = "Zope Location";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
