{ stdenv
, buildPythonPackage
, fetchPypi
, zope_schema
}:

buildPythonPackage rec {
  pname = "zope.filerepresentation";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d775ebba4aff7687e0381f050ebda4e48ce50900c1438f3f7e901220634ed3e0";
  };

  propagatedBuildInputs = [ zope_schema ];

  meta = with stdenv.lib; {
    homepage = http://zopefilerepresentation.readthedocs.io/;
    description = "File-system Representation Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
