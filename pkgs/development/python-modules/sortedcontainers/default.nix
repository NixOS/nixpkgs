{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fm0w5id2yhqld95hg2m636vjgkz377rvgdfqaxc25vbylr9lklp";
  };

  # pypi tarball does not come with tests
  doCheck = false;

  meta = {
    description = "Python Sorted Container Types: SortedList, SortedDict, and SortedSet";
    homepage = http://www.grantjenks.com/docs/sortedcontainers/;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
