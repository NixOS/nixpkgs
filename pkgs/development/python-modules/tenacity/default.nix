{ lib, buildPythonPackage, fetchPypi, isPy27, isPy3k
, pbr, six, futures, monotonic, typing, setuptools_scm
, pytest, sphinx, tornado, typeguard
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "6.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zsdajdpcjd7inrl7r9pwiyh7qpgh9jk7g2bj1iva2d3n0gijkg1";
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
