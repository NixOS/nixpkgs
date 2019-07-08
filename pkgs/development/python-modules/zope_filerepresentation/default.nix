{ stdenv
, buildPythonPackage
, fetchPypi
, zope_schema
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9bff2b2492b2fe716ee54538441a98d6145d1de87dd921eaa44ac834fbb63b6";
  };

  propagatedBuildInputs = [ zope_schema ];

  meta = with stdenv.lib; {
    homepage = http://zopefilerepresentation.readthedocs.io/;
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
