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
, packageurl-python
}:

buildPythonPackage rec {
  pname = "tern";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7ce55a500061e1160b040e75dc38d0eccc790a2b70fa3b7ad1b4fb715c18fc9";
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
    license = licenses.bsd2;
    maintainers = teams.determinatesystems.members;
  };
}
