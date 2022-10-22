{ lib
, buildPythonPackage
, fetchPypi
, zope-event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dba5f530fec3f0988d83b78cc591b58c0b6eb8431a85edd1569a0539a8a5a0e";
  };

  propagatedBuildInputs = [ zope-event ];

  doCheck = false; # Circular deps.

  meta = with lib; {
    description = "Zope.Interface";
    homepage = "https://zope.org/Products/ZopeInterface";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
