{ lib
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.5.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v+4fP/YhQ4GUmeNI9bin86oCWfmspeDdrnOR0Fnc5nE=";
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
