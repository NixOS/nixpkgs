{ lib
, fetchPypi
, buildPythonPackage
, numpy
, python-lz4
, uproot-methods
, awkward
, cachetools
, pythonOlder
, pytestrunner
, pytest
, backports_lzma
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "3.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "313bdcefa7873ffe051fef8df105cd59680c5194a2114503d8a40bbc67adea01";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest ]
    ++ lib.optionals (pythonOlder "3.3") [ backports_lzma ];
  propagatedBuildInputs = [ numpy python-lz4 cachetools uproot-methods awkward ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/uproot;
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
