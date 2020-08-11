{ stdenv, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter_client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "877109d0691376f8ffb380ec1daf9b867958231065660277dbc5ccf0b4bf87d0";
  };

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    wurlitzer
    jupyter_client
    pyzmq
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
