{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "607294c6e291a270948420f7ffa1fb3ed47384a4c08db6d1e9c92d08a6981982";
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
