{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic, setuptools_scm
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4eb168dbf55ed2cae27e7c6b2bd48ab54dabaf294177d998330cf59f294c112";
  };

  nativeBuildInputs = [ pbr setuptools_scm ];
  propagatedBuildInputs = [ six ]
    ++ lib.optionals isPy27 [ futures monotonic ];

  checkInputs = [ pytest sphinx tornado ];
  checkPhase = if isPy27 then ''
    pytest --ignore='tenacity/tests/test_asyncio.py'
  '' else ''
    pytest
  '';

  meta = with lib; {
    homepage = https://github.com/jd/tenacity;
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
