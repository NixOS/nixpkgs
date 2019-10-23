{ buildPythonApplication, click, fetchPypi, hypothesis, mypy, pytest
, pytestcov, pytestrunner, stdenv, stringcase
}:

buildPythonApplication rec {
  pname = "zfs-replicate";
  version = "1.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0386xc6rw6bhzw2a08g90afb3snqhm1ikx65bjfh22ha69fwmga8";
  };

  checkInputs = [
    hypothesis
    mypy
    pytest
    pytestcov
  ];

  buildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    click
    stringcase
  ];

  doCheck = true;

  checkPhase = ''
    pytest --doctest-modules
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/alunduil/zfs-replicate;
    description = "ZFS Snapshot Replication";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
