{ lib, fetchPypi, buildPythonPackage, isPy27
, awkward
, backports_lzma
, cachetools
, lz4
, pytestrunner
, pytest
, pkgconfig
, mock
, numpy
, requests
, uproot-methods
, xxhash
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06s0lym5md59pj8w89acnwk0i0hh92az187h4gz22mb849h308pw";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [
    lz4
    mock
    pkgconfig
    pytest
    requests
    xxhash
  ] ++ lib.optional isPy27 backports_lzma;

  propagatedBuildInputs = [
    numpy
    cachetools
    uproot-methods
    awkward
  ];

  # skip tests which do network calls
  checkPhase = ''
    pytest tests -k 'not hist_in_tree and not branch_auto_interpretation'
  '';

  meta = with lib; {
    homepage = https://github.com/scikit-hep/uproot;
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
