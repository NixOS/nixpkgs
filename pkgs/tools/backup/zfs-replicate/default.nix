{ buildPythonApplication, click, fetchPypi, hypothesis, mypy, pytest
, pytestcov, pytestrunner, lib, stringcase
}:

buildPythonApplication rec {
  pname = "zfs-replicate";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2cb9d4670a6e12d14a446c10d857862e91af6e4526f607e08b41bde89953bb8";
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

  meta = with lib; {
    homepage = "https://github.com/alunduil/zfs-replicate";
    description = "ZFS Snapshot Replication";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
