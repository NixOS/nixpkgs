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
    hash = "sha256-mWWqGFCbdXa71LBoli2amkgozsjOIu5aNl3bzr/6CfU=";
  };

  propagatedBuildInputs = [
    decorator
    requests
  ];

  # Tests require internet connection
  doCheck = false;
  pythonImportsCheck = [ "stashy" ];

  meta = with lib; {
    description = "Python client for the Atlassian Bitbucket Server (formerly known as Stash) REST API";
    homepage = "https://github.com/cosmin/stashy";
    license = licenses.asl20;
    maintainers = with maintainers; [ mupdt ];
  };
}
