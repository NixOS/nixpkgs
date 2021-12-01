{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter-client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b19ea224f183dbff8ff0031bee35ae6b5b3a6eef4aa84cfab04e3bc3e304b91";
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
