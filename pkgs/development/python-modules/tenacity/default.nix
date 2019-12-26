{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic, setuptools_scm
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "5.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e664bd94f088b17f46da33255ae33911ca6a0fe04b156d334b601a4ef66d3c5f";
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
