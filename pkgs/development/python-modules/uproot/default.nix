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
, mock
, requests
, backports_lzma
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "3.4.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1df24d1f193b044cc4d6ef98e183a853655b568b7b15173d88b0d2a79e1226da";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [ pytest pkgconfig lz4 mock requests ]
    ++ lib.optionals (pythonOlder "3.3") [ backports_lzma ];
  propagatedBuildInputs = [ numpy cachetools uproot-methods awkward ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/uproot;
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
