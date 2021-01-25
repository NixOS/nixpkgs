{ lib
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8251f06a77985a2729a8bdbefbae79ee78567dddc3acbd499b87e705ca59fe24";
  };

  propagatedBuildInputs = [ zope_event ];

  doCheck = false; # Circular deps.

  meta = with lib; {
    description = "Zope.Interface";
    homepage = "https://zope.org/Products/ZopeInterface";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
