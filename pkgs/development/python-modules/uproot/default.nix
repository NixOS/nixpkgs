{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.8.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f790cb8a704b44ffd5efe5a9cb46204a042b55a9cddeb61434193cfd534275c";
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
