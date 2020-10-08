{ lib, buildPythonPackage, fetchPypi, isPy27, isPy3k
, pbr, six, futures, monotonic, typing, setuptools_scm
, pytest, sphinx, tornado, typeguard
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
    ++ lib.optionals isPy27 [ futures monotonic typing ];

  checkInputs = [ pytest sphinx tornado ]
    ++ lib.optionals isPy3k [ typeguard ];
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
