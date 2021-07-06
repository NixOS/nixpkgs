{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, isPy3k
, pythonOlder
, greenlet
, importlib-metadata
, mock
, pysqlite ? null
, pytestCheckHook
, pytest_xdist
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.4.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k3yfarfa0hcc0bza6nccy685gnmq6gikynqayrvddx6y7si0lnj";
  };

  propagatedBuildInputs = [
    greenlet
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  dontUseSetuptoolsCheck = true;

  # disable mem-usage tests on mac, has trouble serializing pickle files
  disabledTests = lib.optionals stdenv.isDarwin [
    "MemUsageWBackendTest"
    "MemUsageTest"
  ];

  meta = with lib; {
    homepage = "http://www.sqlalchemy.org/";
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
