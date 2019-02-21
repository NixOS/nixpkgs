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
  version = "3.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46a99b590c062ad01f2721af04e6262986f0b53e51dfedf68bf4049bb015c12f";
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
