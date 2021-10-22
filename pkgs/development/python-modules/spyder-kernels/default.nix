{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter-client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab5c2a90d44f0a26e7a6862e3cb73bb2d7084bc72f9336d8c2d2a78c145c4645";
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
