{ lib, buildPythonPackage, fetchPypi, isPy27, isPy3k
, pbr, six, futures ? null, monotonic ? null, typing ? null, setuptools-scm
, pytest, sphinx, tornado, typeguard
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "8.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43242a20e3e73291a28bcbcacfd6e000b02d3857a9a9fff56b297a27afdc932f";
  };

  nativeBuildInputs = [ pbr setuptools-scm ];
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
