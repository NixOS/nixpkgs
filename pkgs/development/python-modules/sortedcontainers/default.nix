{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88";
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
