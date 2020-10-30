{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba";
  };

  # pypi tarball does not come with tests
  doCheck = false;

  meta = {
    description = "Python Sorted Container Types: SortedList, SortedDict, and SortedSet";
    homepage = "http://www.grantjenks.com/docs/sortedcontainers/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
