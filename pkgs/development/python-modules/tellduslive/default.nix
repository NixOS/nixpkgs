{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  requests,
  requests-oauthlib,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tellduslive";
  version = "0.10.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fWL+VSvoT+dT0jzD8DZEMxzTlqj4TYGCJPLpeui5q64=";
  };

  propagatedBuildInputs = [
    docopt
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "tellduslive" ];

  meta = with lib; {
    description = "Python module to communicate with Telldus Live";
    mainProgram = "tellduslive";
    homepage = "https://github.com/molobrakos/tellduslive";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ fab ];
  };
}
