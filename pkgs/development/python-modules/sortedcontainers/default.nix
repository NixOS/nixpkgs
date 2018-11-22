{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b74f2756fb5e23512572cc76f0fe0832fd86310f77dfee54335a35fb33f6b950";
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
