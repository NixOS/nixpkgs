{ lib
, buildPythonPackage
, debian-inspector
, docker
, dockerfile-parse
, fetchPypi
, gitpython
, idna
, license-expression
, packageurl-python
, pbr
, prettytable
, pythonOlder
, pyyaml
, regex
, requests
, stevedore
}:

buildPythonPackage rec {
  pname = "tern";
  version = "2.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MELPpz7UeOKSAW7hC2xDIog/bdLUflU00vvIbAePNBA=";
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
    license-expression
    requests
    stevedore
    debian-inspector
    regex
    gitpython
    prettytable
    idna
    packageurl-python
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "tern"
  ];

  meta = with lib; {
    description = "A software composition analysis tool and Python library that generates a Software Bill of Materials for container images and Dockerfiles";
    homepage = "https://github.com/tern-tools/tern";
    changelog = "https://github.com/tern-tools/tern/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = teams.determinatesystems.members;
  };
}
