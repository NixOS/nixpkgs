{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sortedcontainers";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59cc937650cf60d677c16775597c89a960658a09cf7c1a668f86e1e4464b10a1";
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
