{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, blockdiag
, seqdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-seqdiag";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-THJ1ra/W2X/lQaDjGbL27VMn0lWPJApwgKMrPhL0JY0=";
  };

  propagatedBuildInputs = [ sphinx blockdiag seqdiag ];

  pythonImportsCheck = [ "sphinxcontrib.seqdiag" ];

  meta = with lib; {
    description = "Sphinx seqdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-seqdiag";
    maintainers = with maintainers; [ davidtwco ];
    license = licenses.bsd2;
  };
}
