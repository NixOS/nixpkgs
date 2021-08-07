{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter_client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "1.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cecb0ca0115a42bab864c199a737c859a8534a510fc7edfa33dc42abcbb5287f";
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
