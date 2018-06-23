{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.8.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42b6482d085b699a534f0a3ec352e96d4653e31c8839855c8a852618f54e27d8";
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
