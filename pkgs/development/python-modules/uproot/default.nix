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
  version = "3.2.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jxsv0038glxz87skjxr58fafwyqilivkrygpvk4nkp866i5kz2k";
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
