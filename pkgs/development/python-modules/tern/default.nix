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
  version = "2.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yMIvFiliEHrbZMqvX3ZAROWcqii5VmB54QEYHGRJocA=";
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
    maintainers = [ ];
  };
}
