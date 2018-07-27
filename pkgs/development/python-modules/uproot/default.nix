{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fb8dd19bd1f1ed376a96e92b32ff44f7d3688bda55eda9055898111fdac8391";
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
