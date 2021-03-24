{ lib, buildPythonPackage, fetchPypi, isPy27, isPy3k
, pbr, six, futures ? null, monotonic ? null, typing ? null, setuptools_scm
, pytest, sphinx, tornado, typeguard
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bd16ef5d3b985647fe28dfa6f695d343aa26479a04e8792b9d3c8f49e361ae1";
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
