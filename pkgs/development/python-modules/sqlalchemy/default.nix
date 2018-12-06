{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, pytest
, mock
, isPy3k
, pysqlite
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84412de3794acee05630e7788f25e80e81f78eb4837e7b71d0499129f660486a";
  };

  patches = [
    # fix for failing doc tests
    # https://bitbucket.org/zzzeek/sqlalchemy/issues/4370/sqlite-325x-docs-tutorialrst-doctests-fail
    (fetchpatch {
      name = "doc-test-fixes.patch";
      url = https://bitbucket.org/zzzeek/sqlalchemy/commits/63279a69e2b9277df5e97ace161fa3a1bb4f29cd/raw;
      sha256 = "1x25aj5hqmgjdak4hllya0rf0srr937k1hwaxb24i9ban607hjri";
    })
  ];

  checkInputs = [
    pytest
    mock
#     Disable pytest_xdist tests for now, because our version seems to be too new.
#     pytest_xdist
  ] ++ lib.optional (!isPy3k) pysqlite;

  checkPhase = ''
    py.test -k "not test_round_trip_direct_type_affinity"
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
