{ stdenv
, buildPythonPackage
, fetchPypi
, zope_proxy
}:

buildPythonPackage rec {
  pname = "zope.location";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nj9da4ksiyv3h8n2vpzwd0pb03mdsh7zy87hfpx72b6p2zcwg74";
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
