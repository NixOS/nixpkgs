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
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.4.37";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Noj5LGLbbF3yaOImSJEHjxfsuR4xQbQA8uKND3V5beo=";
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
