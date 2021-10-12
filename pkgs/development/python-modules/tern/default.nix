{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, docker
, dockerfile-parse
, requests
, stevedore
, pbr
, debian-inspector
, regex
, GitPython
, prettytable
, idna
}:

buildPythonPackage rec {
  pname = "tern";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfd59431cafd6adf05ccb94be964098d9301f83a03bf715def7861811e4a4b74";
  };

  preBuild = ''
    cp requirements.{in,txt}
  '';

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    pyyaml
    docker
    dockerfile-parse
    requests
    stevedore
    debian-inspector
    regex
    GitPython
    prettytable
    idna
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "tern"
  ];

  meta = with lib; {
    description = "A software composition analysis tool and Python library that generates a Software Bill of Materials for container images and Dockerfiles";
    homepage = "https://github.com/tern-tools/tern";
    license = licenses.bsd2;
    maintainers = teams.determinatesystems.members;
  };
}
