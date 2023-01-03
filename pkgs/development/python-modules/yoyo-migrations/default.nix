{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, sqlparse
, tabulate
}:

buildPythonPackage rec {
  pname = "yoyo-migrations";
  version = "8.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ggYGoD4mLPHNT1niVsKPpEZCUiTVuCo9EnX9eBeFI+Q=";
  };

  propagatedBuildInputs = [ setuptools sqlparse tabulate ];

  doCheck = false; # pypi tarball does not contain tests

  pythonImportsCheck = [ "yoyo" ];

  meta = with lib; {
    description = "Database schema migration tool";
    homepage = "https://ollycope.com/software/yoyo";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
