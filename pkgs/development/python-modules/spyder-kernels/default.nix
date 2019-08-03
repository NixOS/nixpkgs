{ stdenv, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter_client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e124fad5203b748005e952cf33b44695dbb9d92f5e0dc5443e7ca0db817f400";
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
