{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "4.7.1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "4bb937e998be9d5e345f486693e477ba79e4344674484001a0b646be1d530487";
  };

  propagatedBuildInputs = [ zope_event ];

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = http://zope.org/Products/ZopeInterface;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
