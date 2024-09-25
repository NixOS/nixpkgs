{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-schema,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yza3iGspJ2+C8WhfPykfQjXmac2HhdFHQtRl0Trvaqs=";
  };

  propagatedBuildInputs = [
    zope-interface
    zope-schema
  ];

  checkPhase = ''
    cd src/zope/filerepresentation && python -m unittest
  '';

  meta = with lib; {
    homepage = "https://zopefilerepresentation.readthedocs.io/";
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
