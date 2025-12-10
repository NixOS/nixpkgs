{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "stashy";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x89zazwxnsx6rdfw8nfr372hj4sk8nrcs5hsjxpcxcva0calrcr";
  };

  propagatedBuildInputs = [
    decorator
    requests
  ];

  # Tests require internet connection
  doCheck = false;
  pythonImportsCheck = [ "stashy" ];

  meta = {
    description = "Python client for the Atlassian Bitbucket Server (formerly known as Stash) REST API";
    homepage = "https://github.com/cosmin/stashy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mupdt ];
  };
}
