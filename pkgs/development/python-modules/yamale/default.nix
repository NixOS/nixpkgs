{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytest
, pyyaml
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "3.0.4";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = version;
    sha256 = "1xjvah4r3gpwk4zxql3c9jpllb34k175fm6iq1zvsd2vv2fwf8s2";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel_yaml
  ];

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "A schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
  };
}
