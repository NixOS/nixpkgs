{ stdenv, lib, fetchPypi, buildPythonPackage, isPy27, isPy3k, pythonAtLeast
, pythonOlder
, mock
, greenlet
, importlib-metadata
, pysqlite ? null
, pytestCheckHook
, pytest_xdist
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.4.7";

  disabled = !(isPy27 || pythonAtLeast "3.6");

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aghjm27k1q9kn2yz1871qvaxsaxbxy9kdw1vckcz34cv2bmy4c4";
  };

  checkInputs = [
    pytestCheckHook
    pytest_xdist
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  pytestFlagsArray = [ "-n auto" ];

  propagatedBuildInputs = lib.optional isPy3k greenlet
    ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  dontUseSetuptoolsCheck = true;

  # disable mem-usage tests on mac, has trouble serializing pickle files
  disabledTests = lib.optionals isPy3k [ "exception_persistent_flush_py3k "]
    ++ lib.optionals stdenv.isDarwin [ "MemUsageWBackendTest" "MemUsageTest" ];

  meta = with lib; {
    homepage = "http://www.sqlalchemy.org/";
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
