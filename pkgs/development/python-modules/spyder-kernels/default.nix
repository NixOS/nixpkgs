{ stdenv, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter_client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48f71252d0a7c7a91242e70d47618a432ee5f9f6666e651473a54bc55513571c";
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
