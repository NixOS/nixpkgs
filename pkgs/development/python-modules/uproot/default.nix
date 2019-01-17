{ lib
, fetchPypi
, buildPythonPackage
, numpy
, uproot-methods
, awkward
, cachetools
, pythonOlder
, pytestrunner
, pytest
, pkgconfig
, lz4
, backports_lzma
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "3.2.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a871f57529e3df170aa5556c1353a64077277644baecabb18d042954f2af9030";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest pkgconfig lz4 ]
    ++ lib.optionals (pythonOlder "3.3") [ backports_lzma ];
  propagatedBuildInputs = [ numpy cachetools uproot-methods awkward ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/uproot;
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
