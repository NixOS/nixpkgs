{ lib
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b18a855f8504743e0a2d8b75d008c7720d44e4c76687e13f959e35d9a13eb397";
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
