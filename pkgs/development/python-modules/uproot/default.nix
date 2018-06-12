{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.8.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e67aa4e666692c05e308fbd169b9bcfa82bc7af561a0e207f1bde0c9da2f0a29";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/uproot;
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
