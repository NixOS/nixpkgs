{ lib, buildPythonPackage, fetchPypi, isPy27
, pbr, six, futures, monotonic
, pytest, sphinx, tornado
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12z36fq6qfn9sgd1snsfwrk5j2cw29bsb7mkb0g818fal41g7dr4";
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
