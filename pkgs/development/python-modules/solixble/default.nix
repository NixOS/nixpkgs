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
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "flip-dots";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-7tgQHYagJi3ECiW/gQzx+ptx7KHdWyHSXOfk5cnaGOs=";
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
