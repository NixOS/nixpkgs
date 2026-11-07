{
  buildPythonPackage,
  fetchFromGitHub,

  bleak,
  bleak-retry-connector,
  cryptography,
  pycryptodome,
  setuptools,
}:

buildPythonPackage rec {
  pname = "SolixBLE";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "flip-dots";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-LGETO3+5AutMt+qpZyINOw+RR0JoGEk3PQSBhkwU800=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
    pycryptodome
  ];
}
