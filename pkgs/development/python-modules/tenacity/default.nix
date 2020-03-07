{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic, setuptools_scm
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72f397c2bb1887e048726603f3f629ea16f88cb3e61e4ed3c57e98582b8e3571";
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
