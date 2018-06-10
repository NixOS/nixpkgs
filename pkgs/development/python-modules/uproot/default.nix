{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.8.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "121ggyl5s0q66yrbdfznvzrc793zq1w2xnr3baadlzfvqdlkhgj7";
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
