{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k, isPy35, fetchpatch
, mock
, pysqlite
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2f25c7f410338d31666d7ddedfa67570900e248b940d186b48461bd4e5569a1";
  };

  patches = [
    # fix test_pyodbc_extra_connect_azure test failure
    (fetchpatch {
      url = "https://github.com/sqlalchemy/sqlalchemy/commit/7293b3dc0e9eb3dae84ffd831494b85355df8e73.patch";
      sha256 = "1z61lzxamz74771ddlqmbxba1dcr77f016vqfcmb44dxb228w2db";
    })
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
  disabledTests = lib.optionals isPy35 [ "exception_persistent_flush_py3k "]
    ++ lib.optionals stdenv.isDarwin [ "MemUsageWBackendTest" "MemUsageTest" ];

  meta = with lib; {
    homepage = "http://www.sqlalchemy.org/";
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
