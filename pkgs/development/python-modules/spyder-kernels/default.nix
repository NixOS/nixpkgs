{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter_client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "416534d7504c0f337e6e6e2cbd893d1866ad20d3bec99a94ad617d2fd60699ae";
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

  meta = with lib; {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://docs.spyder-ide.org/current/ipythonconsole.html";
    downloadPage = "https://github.com/spyder-ide/spyder-kernels/releases";
    changelog = "https://github.com/spyder-ide/spyder-kernels/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
