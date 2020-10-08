{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pytest
, construct }:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.1.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3ecd63d997fbcf6e5322dc47c1f02615f1d9611cba01ec18e9c9f8c14ed824b";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ construct ];

  # no checks from Pypi - https://github.com/happyleavesaoc/python-snapcast/issues/23
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
