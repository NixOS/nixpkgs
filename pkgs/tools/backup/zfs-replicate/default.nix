{ buildPythonApplication, click, fetchPypi, hypothesis, mypy, pytest
, pytestcov, pytestrunner, stdenv, stringcase
}:

buildPythonApplication rec {
  pname = "zfs-replicate";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f1vjn4xw6xl11z60vsjwkv1msb2g22hvha6lha2vqd6f139vjxj";
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
    homepage = "https://github.com/alunduil/zfs-replicate";
    description = "ZFS Snapshot Replication";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
