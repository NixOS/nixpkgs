{ stdenv, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a13cefb569ef9f63814cb5fcf3d0db66e09d2d7e6cc68c703d5118b2d7ba062b";
  };

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    wurlitzer
  ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://github.com/spyder-ide/spyder-kernels";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
