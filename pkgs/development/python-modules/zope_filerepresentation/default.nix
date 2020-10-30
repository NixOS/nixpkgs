{ stdenv
, buildPythonPackage
, fetchPypi
, zope_schema
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mp2r80v6ns92j089l7ngh8l9fk95g2661vkp4vqw7c71irs9g1z";
  };

  propagatedBuildInputs = [ zope_interface zope_schema ];

  checkPhase = ''
    cd src/zope/filerepresentation && python -m unittest
  '';

  meta = with stdenv.lib; {
    homepage = "https://zopefilerepresentation.readthedocs.io/";
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
