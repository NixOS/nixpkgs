{ lib, buildPythonPackage, fetchPypi, isPy27, isPy3k
, pbr, six, futures ? null, monotonic ? null, typing ? null, setuptools-scm
, pytest, sphinx, tornado, typeguard
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5IxDf9+TQPVma5LNeZDpa8X8lV4SmLr0qQfjlyBnpEU=";
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
