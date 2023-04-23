{ lib, buildPythonPackage, fetchFromGitHub, python }:

buildPythonPackage rec {
  pname = "uri-template";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "uri_template";
    rev = "v${version}";
    hash = "sha256-IAq6GpEwimq45FU0QugLZLSOhwAmC1KbpZKD0zyxsUs=";
  };

  postPatch = ''
    sed -i -e 's/0.0.0/${version}/' setup.py
  '';

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  pythonImportsCheck = [ "uri_template" ];

  meta = with lib; {
    description = "An implementation of RFC 6570 URI Templates";
    homepage = "https://github.com/plinss/uri_template/";
    license = licenses.mit;
    maintainers = [];
  };
}
