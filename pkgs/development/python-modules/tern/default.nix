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
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "749c18ef493ebe3ac28624b2b26c6e38f77de2afd6a6579d2c92393d8fbdbd46";
  };

  patches = [
    # debut was renamed to debian-inspector
    # https://github.com/tern-tools/tern/pull/962
    # NOTE: Has to be in-tree because the upstream patch doesn't apply cleanly
    # to the PyPi source.
    ./0001-Replace-debut-with-debian-inspector.patch
  ];

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
