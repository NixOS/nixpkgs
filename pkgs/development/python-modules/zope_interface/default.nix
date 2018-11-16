{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "4.5.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "57c38470d9f57e37afb460c399eb254e7193ac7fb8042bd09bdc001981a9c74c";
  };

  propagatedBuildInputs = [ zope_event ];

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = http://zope.org/Products/ZopeInterface;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
