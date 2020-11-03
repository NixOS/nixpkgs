{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9c8e53a5472b77f6a391b515c771105011f4b40740ce53af8428d1c8ca20004";
  };

  requiredPythonModules = [ zope_event ];

  doCheck = false; # Circular deps.

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = "http://zope.org/Products/ZopeInterface";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
