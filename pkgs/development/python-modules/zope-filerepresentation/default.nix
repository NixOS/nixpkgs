{ lib
, buildPythonPackage
, fetchPypi
, zope-schema
, zope-interface
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mp2r80v6ns92j089l7ngh8l9fk95g2661vkp4vqw7c71irs9g1z";
  };

  propagatedBuildInputs = [ zope-interface zope-schema ];

  checkPhase = ''
    cd src/zope/filerepresentation && python -m unittest
  '';

  meta = with lib; {
    homepage = "https://zopefilerepresentation.readthedocs.io/";
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
