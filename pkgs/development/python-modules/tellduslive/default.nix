{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tellduslive";
  version = "0.10.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = "tellduslive";
    tag = "v${version}";
    sha256 = "sha256-fWL+VSvoT+dT0jzD8DZEMxzTlqj4TYGCJPLpeui5q64=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docopt
    requests
    requests-oauthlib
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tellduslive" ];

  meta = {
    description = "Python module to communicate with Telldus Live";
    homepage = "https://github.com/molobrakos/tellduslive";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tellduslive";
  };
}
