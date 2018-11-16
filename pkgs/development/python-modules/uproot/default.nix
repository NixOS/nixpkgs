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
  version = "3.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af0a093f0788b8983d07b88fac3094b26c3e28358bc10cdb8d757cc07956f8d4";
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
