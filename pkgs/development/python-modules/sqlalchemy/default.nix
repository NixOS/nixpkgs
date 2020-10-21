{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k, isPy35
, mock
, pysqlite
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18b9am7bsqc4nj3d2h5r93i002apczxfvpfpcqbd6f0385zmrwnj";
  };

  checkInputs = [
    pytestCheckHook
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  dontUseSetuptoolsCheck = true;

  # disable mem-usage tests on mac, has trouble serializing pickle files
  disabledTests = lib.optionals isPy35 [ "exception_persistent_flush_py3k "]
    ++ lib.optionals stdenv.isDarwin [ "MemUsageWBackendTest" "MemUsageTest" ];

  meta = with lib; {
    homepage = "http://www.sqlalchemy.org/";
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
