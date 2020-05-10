{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic, setuptools_scm
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16ikf6n6dw1kzncs6vjc4iccl76f9arln59jhiiai27lzbkr1bi9";
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
    homepage = "https://github.com/jd/tenacity";
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
