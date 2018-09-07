{lib, fetchPypi, buildPythonPackage, numpy}:

buildPythonPackage rec {
  pname = "uproot";
  version = "2.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da71e9e239129ec2ae7a62f9d35aebd46456f05e000ef14f32fe2c9fa8ec92c2";
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
