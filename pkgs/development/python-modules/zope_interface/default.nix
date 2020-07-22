{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03nrl6b8cb600dnnh46y149awvrm0gxyqgwq5hdw3lvys8mw9r20";
  };

  propagatedBuildInputs = [ zope_event ];

  doCheck = false; # Circular deps.

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = "http://zope.org/Products/ZopeInterface";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
