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
  version = "3.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fafe476c26252e4dbd399456323778e76d23dc2f43cf6581a707d1647978610";
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
