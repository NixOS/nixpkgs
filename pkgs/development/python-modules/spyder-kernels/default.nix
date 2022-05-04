{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter-client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pdU20Oil53TX1hbBAqj6LWqkX9MwoLeZuY7vFYNW02w=";
  };

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    wurlitzer
    jupyter-client
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
