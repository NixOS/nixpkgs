{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rjbj9wks7b7n75mbm01y0g2ngyai8yi05ck9gicmcdyix7vw42c";
  };

  nativeBuildInputs = [ pbr ];
  propagatedBuildInputs = [ six ]
    ++ lib.optionals isPy27 [ futures monotonic ];

  checkInputs = [ pytest sphinx tornado ];
  checkPhase = (if isPy27 then ''
    pytest --ignore='tenacity/tests/test_asyncio.py'
  '' else ''
    pytest
  '') + ''
    sphinx-build -a -E -W -b doctest doc/source doc/build
  '';

  meta = with lib; {
    homepage = https://github.com/jd/tenacity;
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
