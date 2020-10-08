{ stdenv
, buildPythonPackage
, fetchPypi
, zope_schema
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fbca4730c871d8e37b9730763c42b69ba44117cf6d0848014495bb301cae2d6";
  };

  propagatedBuildInputs = [ zope_schema ];

  meta = with stdenv.lib; {
    homepage = "https://zopefilerepresentation.readthedocs.io/";
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
