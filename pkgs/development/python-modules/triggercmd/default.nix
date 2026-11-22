{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  websocket-client,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "triggercmd";
  version = "0.0.36";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ky6U0iAoxQMewh+gB7gBG61PuxUnOONe92io6iygGQU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    websocket-client
    pyjwt
  ];

  # Tests require network access and authentication tokens
  doCheck = false;

  pythonImportsCheck = [ "triggercmd" ];

  meta = {
    description = "Python agent for TRIGGERcmd cloud service";
    homepage = "https://github.com/rvmey/triggercmd-python-agent";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
